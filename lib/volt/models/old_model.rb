require 'volt/models/model_wrapper'
require 'volt/models/array_model'
require 'volt/models/model_helpers'
require 'volt/models/model_hash_behaviour'
require 'volt/models/validations'
require 'volt/models/model_state'


class NilMethodCall < NoMethodError
  def true?
    false
  end

  def false?
    true
  end
end

class Model
  include ReactiveTags
  include ModelWrapper
  include ModelHelpers
  include ModelHashBehaviour
  include Validations
  include ModelState

  attr_accessor :attributes
  attr_reader :parent, :path, :persistor, :options

  def initialize(attributes={}, options={}, initial_state=nil)
    self.options = options

    self.send(:attributes=, attributes, true)

    @cache = {}

    # Models stat in a loaded state since they are normally setup from an
    # ArrayModel, which will have the data when they get added.
    @state = :loaded

    @persistor.loaded(initial_state) if @persistor
  end

  # Update the options
  def options=(options)
    @options = options
    @parent = options[:parent]
    @path = options[:path] || []
    @class_paths = options[:class_paths]
    setup_persistor(options[:persistor])
  end

  # Assign multiple attributes as a hash, directly.
  def attributes=(attrs, initial_setup=false)
    @attributes = wrap_values(attrs)

    unless initial_setup
      trigger!('changed')

      # Let the persistor know something changed
      if @persistor
        # the changed method on a persistor should return a promise that will
        # be resolved when the save is complete, or fail with a hash of errors.
        return @persistor.changed
      end
    end
  end
  alias_method :assign_attributes, :attributes=

  # Pass the comparison through
  def ==(val)
    if val.is_a?(Model)
      # Use normal comparison for a model
      return super
    else
      # Compare to attributes otherwise
      return attributes == val
    end
  end

  # Pass through needed
  def !
    !attributes
  end


  tag_all_methods do
    pass_reactive! do |method_name|
      method_name[0] == '_' && method_name[-1] == '='
    end
  end
  def method_missing(method_name, *args, &block)
    if method_name[0] == '_'
      if method_name[-1] == '='
        # Assigning an attribute with =
        assign_attribute(method_name, *args, &block)
      else
        read_attribute(method_name)
      end
    else
      # Call method directly on attributes.  (since they are
      # not using _ )
      attributes.send(method_name, *args, &block)
    end
  end

  # Do the assignment to a model and trigger a changed event
  def assign_attribute(method_name, *args, &block)
    # Free any cached value
    free(method_name)

    self.expand!
    # Assign, without the =
    attribute_name = method_name[0..-2].to_sym

    value = args[0]

    attributes[attribute_name] = wrap_value(value, [attribute_name])
    trigger_by_attribute!('changed', attribute_name)

    # Let the persistor know something changed
    @persistor.changed(attribute_name) if @persistor
  end

  # When reading an attribute, we need to handle reading on:
  # 1) a nil model, which returns a wrapped error
  # 2) reading directly from attributes
  # 3) trying to read a key that doesn't exist.
  def read_attribute(method_name)
    # puts "READ: #{method_name}"
    # Reading an attribute, we may get back a nil model.
    method_name = method_name.to_sym

    if method_name[0] != '_' && attributes == nil
      # The method we are calling is on a nil model, return a wrapped
      # exception.
      return return_undefined_method(method_name)
    else
      # See if the value is in attributes
      value = (attributes && attributes[method_name])

      # Also check @cache
      value ||= (@cache && @cache[method_name])

      if value
        # key was in attributes or cache
        return value
      else
        # Cache the value, will be removed when expanded or something
        # is assigned over it.
        # TODO: implement a timed out cache flusing
        new_model = read_new_model(method_name)
        @cache[method_name] = new_model

        return new_model
      end
    end
  end

  # Get a new model, make it easy to override
  def read_new_model(method_name)
    if @persistor && @persistor.respond_to?(:read_new_model)
      @persistor.read_new_model(method_name)
    else
      if method_name.plural?
        return new_array_model([], @options.merge(parent: self, path: path + [method_name]))
      else
        return new_model(nil, @options.merge(parent: self, path: path + [method_name]))
      end
    end
  end

  def return_undefined_method(method_name)
    # Methods called on nil capture an error so the user can know where
    # their nil calls are.  This error can be re-raised at a later point.
    begin
      raise NilMethodCall.new("undefined method `#{method_name}' for #{self.to_s}")
    rescue => e
      result = e

      # Cleanup backtrace around ReactiveValue's
      # TODO: this could be better
      result.backtrace.reject! {|line| line['lib/models/model.rb'] || line['lib/models/live_value.rb'] }
    end
  end

  def new_model(attributes, options)
    class_at_path(options[:path]).new(attributes, options)
  end

  def new_array_model(attributes, options)
    # Start with an empty query
    options = options.dup
    options[:query] = {}

    ArrayModel.new(attributes, options)
  end

  # Models behave like hashes, so hash properties contain their own scope (updating one should
  # not affect the others)
  def method_scope(method_name, *args)
    if method_name[0] == '_'
      return method_name.to_s.gsub('=', '').to_sym
    end

    return nil
  end


  def trigger_by_attribute!(event_name, attribute, *passed_args)
    trigger_for_scope!([attribute], event_name, *passed_args)
  end

  # Removes an item from the cache
  def free(name)
    @cache.delete(name)
  end

  # If this model is nil, it makes it into a hash model, then
  # sets it up to track from the parent.
  def expand!
    if attributes.nil?
      @attributes = {}
      if @parent
        @parent.expand!

        @parent.send(:"#{@path.last}=", self)
      end
    end
  end

  tag_method(:<<) do
    pass_reactive!
    destructive!
  end
  # Initialize an empty array and append to it
  def <<(value)
    if @parent
      @parent.expand!
    else
      raise "Model data should be stored in sub collections."
    end

    # Grab the last section of the path, so we can do the assign on the parent
    path = @path.last
    result = @parent.send(path)

    if result.nil?
      # If this isn't a model yet, instantiate it
      @parent.send(:"#{path}=", new_array_model([], @options))
      result = @parent.send(path)
    end

    # Add the new item
    result << value

    return value
  end

  def inspect
    "<#{self.class.to_s}:#{object_id} #{attributes.inspect}>"
  end

  def deep_cur
    attributes
  end


  def save!
    # Compute the erros once
    errors = self.errors

    if errors.size == 0
      save_to = options[:save_to]
      if save_to
        if save_to.is_a?(ArrayModel)
          # Add to the collection
          new_model = save_to.append(self.attributes)

          # Set the buffer's id to track the main model's id
          self.attributes[:_id] = new_model._id
          options[:save_to] = new_model

          # TODO: return a promise that resolves if the append works
        else
          # We have a saved model
          return save_to.assign_attributes(self.attributes)
        end
      else
        raise "Model is not a buffer, can not be saved, modifications should be persisted as they are made."
      end

      return Promise.new.resolve({})
    else
      # Some errors, mark all fields
      self.class.validations.keys.each do |key|
        mark_field!(key.to_sym)
      end
      trigger!('changed') # :errors, :marked_errors

      return Promise.new.reject(errors)
    end
  end


  # Returns a buffered version of the model
  tag_method(:buffer) do
    destructive!
  end
  def buffer
    model_path = options[:path]
    model_klass = class_at_path(model_path)

    new_options = options.merge(path: model_path, save_to: self).reject {|k,_| k.to_sym == :persistor }
    model = model_klass.new({}, new_options, :loading)

    if state == :loaded
      setup_buffer(model)
    else
      self.parent.then do
        setup_buffer(model)
      end
    end

    return ReactiveValue.new(model)
  end


  private
    def setup_buffer(model)
      model.attributes = self.attributes
      model.change_state_to(:loaded)
    end

    # Takes the persistor if there is one and create it
    def setup_persistor(persistor)
      if persistor
        @persistor = persistor.new(self)
      end
    end

end
