require 'volt/reactive/reactive_tags'
require 'volt/reactive/reactive_value'

class ReactiveArray
  include ReactiveTags

  def initialize(array=[])
    @array = array
  end

  # Forward any missing methods to the array
  def method_missing(method_name, *args, &block)
    @array.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, private=false)
    @array.respond_to?(method_name)
  end

  def ==(*args)
    @array.==(*args)
  end

  tag_method(:each) do
    destructive!
  end
  # At the moment, each just passes through.
  def each(&block)
    @array.each(&block)
  end

  tag_method(:[]=) do
    pass_reactive!
  end
  def []=(index, value)
    index_val = index.cur

    if index_val < 0
      # Handle a negative index, so we can trigger on the right index
      index_val = size + index_val
    end

    @array[index_val] = value

    # Trigger changed
    trigger_for_index!('changed', index_val)
  end

  # When cells are changed, we don't need to trigger a update on all of the
  # other cells.  Instead we just trigger on the updated cell and all other
  # non-lookup methods.
  def method_scope(method_name, *args)
    if method_name == :[] && args.size == 1 && args[0].is_a?(Fixnum)
      # Array index lookup
      return :[], args[0]
    elsif method_name == :size || method_name == :length
      return :size
    end

    # All other methods
    return nil
  end

  # Trigger on the updated cell, and all other non-lookup methods.
  def trigger_for_index!(event, index)
    trigger_for_scope!([:[], index], event)
    trigger_for_scope!([nil], event)
  end

  # tag_method(:delete_at) do
  #   destructive!
  # end
  # # alias :__old_delete_at :delete_at
  # def delete_at(index)
  #   index_val = index.cur
  #
  #   __clear_element(index)
  #
  #   model = @array.delete_at(index_val)
  #
  #   trigger_on_direct_listeners!('removed', index_val)
  #
  #   # Trigger a changed event for each element in the zone where the
  #   # lookup would change
  #   index.upto(self.size+1) do |position|
  #     trigger_for_index!('changed', position)
  #   end
  #
  #   trigger_size_change!
  #
  #   @persistor.removed(model) if @persistor
  #
  #   return model
  # end
  #
  #
  # # Delete is implemented as part of delete_at
  # tag_method(:delete) do
  #   destructive!
  # end
  # def delete(val)
  #   self.delete_at(@array.index(val))
  # end
  #
  # # Removes all items in the array model.
  # tag_method(:clear) do
  #   destructive!
  # end
  # def clear
  #   @array = []
  #   trigger!('changed')
  # end
  #
  tag_method(:<<) do
    pass_reactive!
    destructive!
  end
  def <<(value)
    result = (@array << value)

    index = self.size - 1

    # Trigger on [] cell lookup's
    trigger_for_index!('changed', index)

    # Trigger that we added
    trigger!('added', index)

    # Trigger size change (size, length)
    trigger_size_change!

    return result
  end

  tag_method(:+) do
    pass_reactive!
    destructive!
  end
  def +(array)
    old_size = self.size

    # TODO: += is funky here, might need to make a .plus! method
    result = ReactiveArray.new(@array.dup + array)

    old_size.upto(result.size-1) do |index|
      trigger_for_index!('changed', index)
      trigger!('added', old_size + index)
    end

    trigger_size_change!

    return result
  end

  tag_method(:insert) do
    destructive!
    pass_reactive!
  end
  def insert(index, *objects)
    result = @array.insert(index, *objects)

    # All objects from index to the end have "changed"
    index.upto(result.size-1) do |idx|
      trigger_for_index!('changed', idx)
    end

    objects.size.times do |count|
      trigger!('added', index+count)
    end

    trigger_size_change!

    return result
  end
  #
  # def trigger_on_direct_listeners!(event, *args)
  #   trigger_by_scope!(event, *args) do |scope|
  #     # Only if it is bound directly to us.  Don't pass
  #     # down the chain
  #     !scope || scope[0] == nil
  #   end
  #
  # end
  #
  def trigger_size_change!
    trigger_for_scope!([:size], 'changed')
  end
  #
  # # TODO: This is an opal work around.  Currently there is a bug with destructuring
  # # method_name, *args, block = scope
  # def split_scope(scope)
  #   if scope
  #     scope = scope.dup
  #     method_name = scope.shift
  #     block = scope.pop
  #
  #     return method_name, scope, block
  #   else
  #     return nil,[],nil
  #   end
  # end
  #
  # # Trigger the changed event to any values fetched either through the
  # # lookup ([]), #last, or any fetched through the array its self. (sum, max, etc...)
  # # On an array, when an element is added or removed, we need to trigger change
  # # events on each method that does the following:
  # # 1. uses the whole array (max, sum, etc...)
  # # 2. accesses this specific element - array[index]
  # # 3. accesses an element via a method (first, last)
  # def trigger_for_index!(event_name, index, *passed_args)
  #   self.trigger_by_scope!(event_name, *passed_args) do |scope|
  #     # method_name, *args, block = scope
  #     method_name, args, block = split_scope(scope)
  #
  #     result = case method_name
  #     when nil
  #       # no method name means the event was bound directly, we don't
  #       # want to trigger changed on the array its self.
  #       false
  #     when :[]
  #       # Extract the current index if its reactive
  #       arg_index = args[0].cur
  #
  #       # TODO: we could handle negative indicies better
  #       arg_index == index.cur || arg_index < 0
  #     when :last
  #       index.cur == self.size-1
  #     when :first
  #       index.cur == 0
  #     when :size, :length
  #       # Size does not depend on the contents of the cells
  #       false
  #     else
  #       true
  #     end
  #
  #     result = false if method_name == :reject
  #
  #     result
  #   end
  # end
  #
  # def inspect
  #   "#<#{self.class.to_s}:#{object_id} #{@array.inspect}>"
  # end
  #
  # # tag_method(:count) do
  # #   destructive!
  # # end
  # def count(*args, &block)
  #   # puts "GET COUNT"
  #   if block
  #     run_block = Proc.new do |source|
  #       count = 0
  #       source.cur.size.times do |index|
  #         val = source[index]
  #         result = block.call(val).cur
  #         if result == true
  #           count += 1
  #         end
  #       end
  #
  #       count
  #     end
  #
  #     return ReactiveBlock.new(self, block, run_block)
  #   else
  #     @array.count(*args)
  #   end
  # end
  #
  # def reject(*args, &block)
  #   if block
  #     run_block = Proc.new do |source|
  #       puts "RUN REJECT"
  #       new_array = []
  #       source.cur.size.times do |index|
  #         val = source[index]
  #         result = block.call(val).cur
  #         if result != true
  #           new_array << val.cur
  #         end
  #       end
  #
  #       ReactiveArray.new(new_array)
  #     end
  #
  #     return ReactiveBlock.new(self, block, run_block)
  #   else
  #     @array.count
  #   end
  # end
  #
  # private
  #
  #   def __clear_element(index)
  #     # Cleanup any tracking on an index
  #     if @reactive_element_listeners && self[index].reactive?
  #       @reactive_element_listeners[index].remove
  #       @reactive_element_listeners.delete(index)
  #     end
  #   end
  #
  #   def __track_element(index, value)
  #     __setup_tracking(index, value) do |event, index, args|
  #       trigger_for_index!(event, index, *args)
  #     end
  #   end

end