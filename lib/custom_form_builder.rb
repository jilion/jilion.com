class CustomFormBuilder < ActionView::Helpers::FormBuilder
  
  def label(method, text = nil, options = {})
    if options[:require]
      text += "<abbr title='required'>*</abbr>"
    end
    if options[:notice]
      text += " <em>#{options[:notice]}</em>"
    end
    super(method, text, options)
  end

  %w[text_field collection_select select date_select password_field text_area file_field].each do |method_name|
    define_method(method_name) do |field_name, *args|
      options = args.extract_options!
      
      object = @template.instance_variable_get("@#{@object_name}")
      
      unless object.nil?
        errors = object.errors.on(field_name.to_sym)
        if errors
          if errors.is_a?(Array)
            last_error = " and #{errors.pop}"
            first_errors = errors.join(", ")
            inline_errors = first_errors + last_error
          else
            inline_errors = errors
          end
        end
      end
    
      unless inline_errors.nil?
        super(field_name, options.merge(:id => "")) + "<p class='inline_errors'>This field #{inline_errors}</p>"
      else
        super(field_name, options.merge(:id => ""))
      end
    end
  end
  
  def hidden_field(method, options = {})
    super(method, options.merge(:id => ""))
  end
  
end