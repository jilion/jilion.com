class CustomFormBuilder < ActionView::Helpers::FormBuilder
  
  def label(method, text=nil, options={})
    if options[:require]
      text += "<abbr title='required'>*</abbr>"
    end
    if options[:notice]
      text += " <em>#{options[:notice]}</em>"
    end
    super(method, text.html_safe, options.merge(:for => "#{ActiveModel::Naming.singular(@object.class)}_#{method}"))
  end

  %w[text_field collection_select date_select select password_field text_area file_field hidden_field radio_button].each do |method_name|
    define_method(method_name) do |field_name, *args|      
      unless @object.nil?
        errors = @object.errors[field_name.to_sym]
        if errors.present?
          inline_errors = if errors.is_a?(Array)
            last_error = errors.size == 1 ? '' : " and #{errors.pop}"
            errors.join(", ") + last_error
          else
            errors
          end
        end
      end
      
      args.last.is_a?(Hash) && args.last.merge!(:id => "#{ActiveModel::Naming.singular(@object.class)}_#{field_name}")
      
      super(field_name, *args) + (inline_errors.nil? ? '' : "<span class='inline_errors'>This field #{inline_errors}</span>").html_safe
    end
  end
  
end