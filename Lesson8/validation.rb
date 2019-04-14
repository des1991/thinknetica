module Validation
  protected

  def validate!(field)
    field.each do |field_name, field_param|
      field_length = field_param[:length] || 0

      raise "Error! #{field_name} can't be nil." if field_param[:value].nil?
      raise "Error! #{field_name} can't be empty." if field_param[:value].empty?

      if field_param[:value].to_s.length < field_length
        raise "Error! #{field_name} should be at least #{field_length} symbols."
      end

      if field_param[:format] && field_param[:value] !~ field_param[:format]
        raise "Error! #{field_name} has invalid format."
      end
    end
  end
end
