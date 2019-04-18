module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, option = nil)
      @validation_list ||= {}

      @validation_list["#{name}_#{type}"] = {
        name: "@#{name}".to_sym,
        type: type,
        option: option
      }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate!
      self.class.instance_variable_get(:@validation_list).each do |_key,
                                                                  validator|
        value = instance_variable_get(validator[:name])

        case validator[:type]
        when :presence
          validate_presence(value)
        when :format
          validate_format(value, validator[:option])
        when :type
          validate_type(value, validator[:option])                        
        else
          raise "Invalid validation type."
        end
      end
    end

    def validate_presence(value)
      raise "Empty value." if value.nil? || value == ''
    end

    def validate_format(value, format)
      raise "Invalid format." unless value =~ format
    end

    def validate_type(value, type)
      raise "Invalid type." unless value.is_a?(type)
    end
  end
end
