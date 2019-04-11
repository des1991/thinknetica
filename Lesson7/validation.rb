module Validation
  protected

  def validate!(field)
    field.each do |field_name, field_params|
      field_length = field_params[:length] || 0

      raise "Error! #{field_name} can't be nil." if field_params[:value].nil?
      raise "Error! #{field_name} should be at least #{field_length} symbols." if field_params[:value].to_s.length < field_length
      raise "Error! #{field_name} has invalid format." if field_params[:format] && field_params[:value] !~ field_params[:format]      
    end
  end
end
