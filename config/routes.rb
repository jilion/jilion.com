ActionController::Routing::Routes.draw do |map|
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "pages", :action => "home"
  map.connect 'n/:n', :controller => "pages", :action => "home", :requirements => { :n => /thankyou|confirmed|unsubscribed/ }
  
  map.with_options :controller => 'pages' do |home|
    home.ie '/ie', :action => 'ie'
    # info.ie '/ie', :action => 'ie', :conditions => { :subdomain => false }
    # info.ie '/mobile', :action => 'mobile'
  end
  
  map.resources :sublime, :only => [:index, :show]
  map.video_flash '/sublime/video/flash', :controller => 'sublime', :action => 'show', :id => 'video', :flash => true
  
  map.resources :jobs, :only => [:index, :show]
  
  map.resources :contacts, :only => [:create]
  map.new_contact 'contact', :controller => 'contacts', :action => 'new', :conditions => { :method => :get }
  map.contact_pdf "contact/Jilion-contact.pdf", :controller => 'contacts', :action => 'show', :conditions => { :method => :get }
  
  map.redirect 'admin', :controller => 'admin/contacts'
  map.namespace :admin do |admin|
    admin.resources :jobs, :except => [:destroy]
    admin.resources :contacts, :only => [:index, :show, :update]
  end
  
  Jammit::Routes.draw(map)
end
