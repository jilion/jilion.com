module ContactsHelper
  
  def contact(klass)
    if params[:contact] && params[:contact][:_type] == klass.to_s
      @contact
    else
      klass.constantize.new
    end
  end
  
end
