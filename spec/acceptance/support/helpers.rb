module HelperMethods
  
  def warden
    request.env['warden']
  end
  
  def create_admin(options = {})
    @current_admin ||= begin
      admin = Factory(:admin, options[:admin] || {})
      admin.lock! if options[:locked] == true
      admin
    end
  end
  
  def sign_in_as(resource_name, options={}, &block)
    send(:"sign_in_as_#{resource_name}", { resource_name => options }, &block)
  end
  
  def sign_in_as_admin(options = {}, &block)
    admin = create_admin(options)
    visit "/admin/login"
    fill_in 'Email',    :with => admin.email
    fill_in 'Password', :with => '123456'
    check   'Remember me' if options[:remember_me] == true
    yield if block_given?
    click_button 'Login'
    admin
  end
  
  def sign_out
    click "Logout"
  end
  
end

Rspec.configuration.include(HelperMethods)