require File.dirname(__FILE__) + '/acceptance_helper'

feature "Enthusiast actions:" do
  
  scenario "register my email for the limited release (aka private beta)!" do
    visit "/"
    current_url.should =~ %r(http://[^/]+/)
    
    fill_in "enthusiast_email",                       :with => "john@doe.com"
    fill_in "enthusiast_sites_attributes_0_hostname", :with => "rymai.com"
    fill_in "enthusiast_free_text",                   :with => "I love U!"
    check "enthusiast_interested_in_beta"
    click_button "Notify Me"
    
    current_url.should =~ %r(http://[^/]+/)
    # page.should have_content("Thank you!")
    
    Enthusiast.last.email.should == "john@doe.com"
    Enthusiast.last.free_text.should == "I love U!"
    Enthusiast.last.remote_ip.should be_present
    Enthusiast.last.should be_interested_in_beta
    Enthusiast.last.sites.last.hostname.should == "rymai.com"
  end
  
  scenario "confirm my email for the notification (aka private beta)!" do
    visit "/"
    current_url.should =~ %r(http://[^/]+/)
    
    fill_in "enthusiast_email",                       :with => "john@doe.com"
    fill_in "enthusiast_sites_attributes_0_hostname", :with => "rymai.com"
    fill_in "enthusiast_free_text",                   :with => "I love U!"
    click_button "Notify Me"
    
    current_url.should =~ %r(http://[^/]+/)
    
    visit "/notify/confirmation?confirmation_token=#{Enthusiast.last.confirmation_token}"
    
    page.should have_content("Thank you!")
    
    Enthusiast.last.confirmation_token.should be_nil
    Enthusiast.last.confirmation_sent_at.should be_present
    Enthusiast.last.confirmed_at.should be_present
  end
  
end