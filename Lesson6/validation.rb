module Validation
  protected

  def validate!(field_value, field_name='', field_length=0, field_format=nil)
    raise "Error! #{field_name} can't be nil." if field_value.nil?
    raise "Error! #{field_name} should be at least #{field_length} symbols." if field_value.to_s.length < field_length
    raise "Error! #{field_name} has invalid format." if field_format && field_value !~ field_format
  end
end
