ActionController::Routing::Routes.draw do |map|
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "pages", :action => 'home'
  
  map.with_options :controller => 'pages' do |home|
    home.ie '/ie', :action => 'ie'
    # info.ie '/ie', :action => 'ie', :conditions => { :subdomain => false }
    # info.ie '/mobile', :action => 'mobile'
  end
  
  map.resources :sublime, :only => [:index, :show]
  map.resources :contacts, :only => :create
  map.new_contact 'contact', :controller => 'contacts', :action => 'new', :condiction => { :method => :get }
  
  Jammit::Routes.draw(map)
end
