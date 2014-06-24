require 'volt/controllers/reactive_accessors'

class TestReactiveAccessors
  include ReactiveAccessors

  reactive_accessor :_name
end

describe ReactiveAccessors do
  it "should assign a reactive value" do
    inst = TestReactiveAccessors.new

    inst._name = 'Ryan'
    expect(inst._name).to eq('Ryan')
  end

  it "should start nil" do
    inst = TestReactiveAccessors.new

    expect(inst._name.cur).to eq(nil)
  end

  it "should keep the same reactive value when reassigning" do
    inst = TestReactiveAccessors.new

    inst._name = 'Ryan'
    rv1_id = inst._name.__id__

    inst._name = 'Jim'
    rv2_id = inst._name.__id__

    expect(rv1_id).to eq(rv2_id)
  end

end