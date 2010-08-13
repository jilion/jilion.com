require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Admin protection:" do
  scenario "/admin should be protected" do
    visit "/admin"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
  end
  
  scenario "/admin/enthusiasts should be protected" do
    visit "/admin/enthusiasts"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
    visit "/admin/enthusiasts/1"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
  end
  
  scenario "/admin/djs should be protected" do
    visit "/admin/djs"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
    visit "/admin/djs/1"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
  end
  
  scenario "/admin/analytics/enthusiasts should be protected" do
    visit "/admin/analytics/enthusiasts"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
  end
end

feature "Admin session:" do
  
  scenario "login" do
    create_admin :admin => { :email => "john@doe.com", :password => "123456" }
    
    visit "/admin/login"
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
    # current_url.should =~ %r(http://[^/]+/admin/login)
    fill_in "Email",     :with => "john@doe.com"
    fill_in "Password",  :with => "123456"
    click_button "Login"
    
    visit "/admin"
    
    current_url.should =~ %r(http://[^/]+/admin/enthusiasts)
  end
  
  scenario "logout" do
    sign_in_as :admin, { :email => "john@doe.com" }
    
    visit "/admin"
    
    click_link "Logout"
    
    visit "/admin"
    
    current_url.should =~ %r(http://[^/]+/admin/admins/login)
  end
  
end

feature "Admins actions:" do
  background do
    sign_in_as :admin, { :email => "old@jilion.com", :password => "123456" }
    visit "/admin"
  end
    
  scenario "list enthusiasts" do
    click_link 'Enthusiasts'
    current_url.should =~ %r(http://[^/]+/admin/enthusiasts)
  end
  
  scenario "list delayed jobs" do
    click_link 'Delayed Jobs'
    current_url.should =~ %r(http://[^/]+/admin/djs)
  end
  
  scenario "list analytics (default enthusiasts analytics)" do
    click_link 'Analytics'
    current_url.should =~ %r(http://[^/]+/admin/analytics/enthusiasts)
  end
  
  scenario "edit email" do
    click_link 'old@jilion.com'
    current_url.should =~ %r(http://[^/]+/admin/admins/edit)
    
    fill_in "Email",            :with => "john@doe.com"
    fill_in "Current password", :with => "123456"
    click_button "Update"
    
    sign_out
    
    visit "/admin/login"
    
    fill_in "Email",     :with => "john@doe.com"
    fill_in "Password",  :with => "123456"
    click_button "Login"
    
    visit "/admin"
    
    current_url.should =~ %r(http://[^/]+/admin/enthusiasts)
    page.should have_content("john@doe.com")
  end
  
  scenario "edit password" do
    click_link 'old@jilion.com'
    current_url.should =~ %r(http://[^/]+/admin/admins/edit)
    
    fill_in "Password",              :with => "654321"
    fill_in "Password confirmation", :with => "654321"
    fill_in "Current password",      :with => "123456"
    click_button "Update"
    
    sign_out
    
    visit "/admin/login"
    
    fill_in "Email",     :with => "old@jilion.com"
    fill_in "Password",  :with => "654321"
    click_button "Login"
    
    visit "/admin"
    
    current_url.should =~ %r(http://[^/]+/admin/enthusiasts)
  end
  
end