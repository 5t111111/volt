require 'volt/reactive/reactive_value'

class TestYield
  def call_with_yield
    yield(1)
    yield(2)
  end
end

class TestTriggerable
  include Triggerable
end

class TestMethodScope
  include Triggerable

  def a
    0
  end

  def b
    1
  end

  def method_scope(method_name, *args)
    return method_name
  end
end

class SampleClass
  include ReactiveTags

  tag_method(:break_stuff) do
    destructive!
  end
  def break_stuff
    5
  end

  tag_method(:receive_reactive?) do
    pass_reactive!
  end
  def receive_reactive?(arg1)
    return arg1.reactive?
  end

  def receive_non_reactive?(arg1)
    return arg1.reactive?
  end

  tag_method(:destructive_receive_non_reactive?) do
    destructive!
  end
  def destructive_receive_non_reactive?(arg1)
    return arg1.reactive?
  end
end


class SampleTriggerClass
  include ReactiveTags

  tag_method(:method_that_triggers) { destructive! }
  def method_that_triggers
    trigger!('changed')
  end
end

class SampleNonTriggerClass
  include ReactiveTags

  tag_method(:method_that_triggers) { destructive! }
  def method_that_triggers
    # does not trigger
  end
end

class SampleTriggerClass2
  include ReactiveTags

  tag_method(:method_that_triggers) { destructive! }
  def method_that_triggers
    trigger!('other')
  end
end



describe ReactiveValue do
  before do
    $event_registry = EventRegistry.new
  end

  describe "the basics" do
    it "should have a with method that returns a new reactive value" do
      a = ReactiveValue.new(1)
      b = a.with { |a| a + 1 }
      expect(a.cur).to eq(1)
      expect(b.cur).to eq(2)

      a.cur = 5
      $event_registry.flush!
      expect(b.cur).to eq(6)
    end

    it "should say its reactive" do
      a = 1
      b = ReactiveValue.new(a)

      expect(a.reactive?).to eq(false)
      expect(b.reactive?).to eq(true)
    end

    it "should return a reactive value from any method call (by coercion if necessary)" do
      a = ReactiveValue.new(5)
      b = 10

      c = a + b
      d = b + a
      e = c + d

      expect(c.reactive?).to eq(true)
      expect(d.reactive?).to eq(true)
      expect(e.reactive?).to eq(true)
    end

    it "should work with objects not just numbers (array concat)" do
      a = ReactiveValue.new([1,2,3])
      b = [4]

      c = a + b
      d = b + a
      e = c + d

      expect(c.reactive?).to eq(true)
      expect(d.reactive?).to eq(true)
      expect(e.reactive?).to eq(true)
    end

    it "should return different listeners" do
      a = ReactiveValue.new(1)

      count = 0
      listener1 = a.on('changed') { count += 1 }
      listener2 = a.on('changed') { count += 1 }

      expect(listener1).not_to eq(listener2)
    end

    it "should return a reactive on .is_a?" do
      a = ReactiveValue.new(1)
      b = a.is_a?(Fixnum)

      expect(b.reactive?).to eq(true)
      expect(b.cur).to eq(true)
    end

    it "should return true for a nil? on a nil value" do
      a = ReactiveValue.new(nil)
      b = a.nil?
      expect(b.reactive?).to eq(true)
      expect(a.cur).to eq(nil)

      a = ReactiveValue.new(1)
      b = a.nil?
      expect(b.reactive?).to eq(true)
      expect(a.cur).not_to eq(nil)
    end
  end

  describe "events" do

    it "should trigger an event on its self" do
      a = ReactiveValue.new(5)
      count = 0
      listener = a.on('changed') { count += 1 }
      expect(count).to eq(0)

      a.trigger!('changed')
      $event_registry.flush!

      expect(count).to eq(1)
    end

    it "should bind and trigger on children" do
      a = ReactiveValue.new(1)
      b = a + 10

      count = 0
      b.on('changed') { count += 1 }
      expect(count).to eq(0)

      a.trigger!('changed')
      $event_registry.flush!
      expect(count).to eq(1)
    end

    it "should handle events, even when triggered from the parent" do
      a = ReactiveValue.new(5)
      b = ReactiveValue.new(20)

      c = a + b

      @called = false
      c.on('changed') { @called = true }
      expect(@called).to eq(false)

      a.trigger!('changed')
      $event_registry.flush!
      expect(@called).to eq(true)

      @called = false

      b.trigger!('changed')
      $event_registry.flush!
      expect(@called).to eq(true)
    end

    it "should not trigger an event after the listener has been removed" do
      a = ReactiveValue.new(5)
      count = 0
      listener = a.on('changed') { count += 1 }
      expect(count).to eq(0)

      listener.remove

      a.trigger!('changed')
      $event_registry.flush!

      expect(count).to eq(0)
    end

    it "should track dependencies and trigger on dependants" do
      a = ReactiveValue.new(1)
      b = a + 5

      count = 0
      b.on('changed') { count += 1}
      expect(count).to eq(0)

      a.trigger!('changed')
      $event_registry.flush!

      expect(count).to eq(1)
    end

    it "should trigger up through nested reactive values" do
      a = ReactiveValue.new(1)
      b = ReactiveValue.new(a)

      count = 0
      b.on('changed') { count += 1 }
      expect(count).to eq(0)

      a.trigger!('changed')
      $event_registry.flush!
      expect(count).to eq(1)
    end

    it "should trigger from a triggerable object" do
      a = TestTriggerable.new
      b = ReactiveValue.new(a)

      count = 0
      b.on('changed') { count += 1 }
      expect(count).to eq(0)

      a.trigger!('changed')
      $event_registry.flush!

      expect(count).to eq(1)
    end

    describe "scopes" do
      it "should trigger on a scope" do
        test_method_scope = TestMethodScope.new
        a = ReactiveValue.new(test_method_scope).a
        b = ReactiveValue.new(test_method_scope).b

        count_a = 0
        count_b = 0
        a.on('changed') { count_a += 1 }
        b.on('changed') { count_b += 1 }
        expect(count_a).to eq(0)
        expect(count_b).to eq(0)

        test_method_scope.trigger_for_scope!(:a, 'changed')
        $event_registry.flush!

        expect(count_a).to eq(1)
        expect(count_b).to eq(0)

        test_method_scope.trigger_for_scope!(:b, 'changed')
        $event_registry.flush!

        expect(count_a).to eq(1)
        expect(count_b).to eq(1)
      end
    end

    describe "trigger ids" do
      it "should have the trigger id in any depedents" do
        a = SampleTriggerClass.new

        b = ReactiveValue.new(a)
        c = ReactiveValue.new(a)

        expect(b.trigger_set.has_trigger?(a.object_trigger_id)).to eq(true)
        expect(c.trigger_set.has_trigger?(a.object_trigger_id)).to eq(true)
      end
    end

    describe "triggers from methods" do

      it "should trigger on any ReactiveValue's that are wrapping it" do
        a = ReactiveValue.new(SampleNonTriggerClass.new)

        count = 0
        a.on('changed') { count += 1 }
        expect(count).to eq(0)

        a.method_that_triggers
        $event_registry.flush!
        expect(count).to eq(0)

        a.cur = SampleTriggerClass.new
        $event_registry.flush!
        expect(count).to eq(1)

        a.method_that_triggers
        $event_registry.flush!
        expect(count).to eq(2)
      end

      it "should trigger on any event" do
        a = ReactiveValue.new(SampleTriggerClass2.new)

        count = 0
        a.on('other') { count += 1 }
        expect(count).to eq(0)

        a.method_that_triggers
        $event_registry.flush!

        expect(count).to eq(1)
      end

      it "should trigger the correct event" do
        a = ReactiveValue.new(SampleNonTriggerClass.new)

        count = 0
        other_count = 0
        a.on('changed') { count += 1 }
        a.on('other') { other_count += 1 }
        expect(count).to eq(0)
        expect(other_count).to eq(0)

        a.method_that_triggers
        $event_registry.flush!
        expect(count).to eq(0)

        a.cur = SampleTriggerClass.new
        $event_registry.flush!
        expect(count).to eq(1)

        a.method_that_triggers
        $event_registry.flush!
        expect(count).to eq(2)

        # Note: .cur= triggers changed
        a.cur = SampleTriggerClass2.new
        $event_registry.flush!
        expect(other_count).to eq(0)

        a.method_that_triggers
        $event_registry.flush!
        expect(count).to eq(3)
        expect(other_count).to eq(1)
      end

      it "should trigger through two different paths" do
        source = SampleTriggerClass.new
        a = ReactiveValue.new(source)
        b = ReactiveValue.new(source)

        count = 0
        count2 = 0
        a.on('changed') { count += 1 }
        b.on('changed') { count2 += 1 }

        expect(count).to eq(0)
        expect(count2).to eq(0)

        a.method_that_triggers
        $event_registry.flush!

        expect(count).to eq(1)
        expect(count2).to eq(1)
      end
    end
  end

  describe "tagged methods" do

    it "should let a class specify methods as destructive" do
      a = ReactiveValue.new(SampleClass.new)
      result = a.break_stuff
      expect(result).to eq(5)
      expect(result.reactive?).to eq(false)
    end

    it "should pass reactive values when asked" do
      a = ReactiveValue.new(SampleClass.new)
      expect(a.receive_reactive?(ReactiveValue.new(1)).cur).to eq(true)
    end

    it "should not pass reactive when not asked" do
      a = ReactiveValue.new(SampleClass.new)
      expect(a.receive_non_reactive?(ReactiveValue.new(1)).cur).to eq(false)
    end

    it "should not pass a reactive value to a destructive method unless it asked for it" do
      a = ReactiveValue.new(SampleClass.new)
      expect(a.destructive_receive_non_reactive?(ReactiveValue.new(1)).cur).to eq(false)
    end
  end


  describe "arrays" do
    it "should add wrapped arrays" do
      a = ReactiveValue.new([1,2])
      b = ReactiveValue.new([3,4])

      c = a + b
      expect(c.size.cur).to eq(4)
    end
  end

  describe "current values" do
    it "should update current values" do
      a = ReactiveValue.new(0)
      expect(a.cur).to eq(0)

      a.cur = 1
      expect(a.cur).to eq(1)
    end
  end

  describe "extraction" do
    it "should give you back the object without any ReactiveValue's if you call .deep_cur on it." do
      a = ReactiveValue.new({_names: [ReactiveValue.new('bob'), ReactiveValue.new('jim')]})

      expect(a.deep_cur).to eq({_names: ['bob', 'jim']})
    end
  end

  describe "blocks" do
    it "should call blocks through the reactive value, and the returned reactive value should depend on the results of the block" do
      a = ReactiveValue.new(TestYield.new)

      count = 0
      a.call_with_yield do |value|
        count += 1
        # value.reactive?.should == true
        # value.even?
      end.cur

      expect(count).to eq(2)
    end
  end

end