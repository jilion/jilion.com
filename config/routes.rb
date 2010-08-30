Jilion::Application.routes.draw do
  
  root :to => "pages#home"
  
  match 'n/:n', :to => 'pages#home', :via => :get, :n => /thankyou|confirmed|unsubscribed/
  match 'ie', :to => 'pages#ie'
  
  match 'sublime/video/flash', :to => redirect('http://sublimevideo.net/demo')
  match 'sublime*', :to => redirect('http://sublimevideo.net')
  
  # resources :sublime, :only => [:index, :show]
  # map.resources :contacts, :only => [:create]
  # map.new_contact 'contact', :controller => 'contacts', :action => 'new', :condiction => { :method => :get }
  # map.contact_pdf "contact/Jilion-contact.pdf", :controller => 'contacts', :action => 'show', :condiction => { :method => :get }
  # 
  # map.redirect 'admin', :controller => 'admin/contacts'
  # map.namespace :admin do |admin|
  #   admin.resources :contacts
  # end
end
