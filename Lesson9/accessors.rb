module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        history_var = "@#{name}_history".to_sym
        histroy_method = "#{name}_history".to_sym


        define_method(name) { instance_variable_get(var_name) }

        define_method("#{name}=") do |value|
          self.send(histroy_method) << value unless value == self.send(name)

          instance_variable_set(var_name, value)
        end

        define_method(histroy_method) do
          instance_variable_get(history_var) ||
            instance_variable_set(history_var, [])
        end
      end
    end

    def strong_attr_accessor(name, class_name)
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=") do |value|
        raise "Invalid type." unless value.is_a?(class_name)

        instance_variable_set(var_name, value)
      end
    end
  end
end
