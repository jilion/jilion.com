ActionController::Routing::Routes.draw do |map|
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "home"
  
  map.with_options :controller => 'pages' do |home|
    home.index '/', :action => 'home'
    home.ie '/ie', :action => 'ie'
    # info.ie '/ie', :action => 'ie', :conditions => { :subdomain => false }
    # info.ie '/mobile', :action => 'mobile'
  end
  
  map.resources :sublime, :only => [:index, :show]
  
end
