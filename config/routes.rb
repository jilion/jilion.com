Jilion::Application.routes.draw do
  
  scope :to => "pages#show", :via => :get do
    root :page => 'home'
    match 'n/:n', :as => :page, :n => /thankyou|confirmed|unsubscribed/, :page => 'home'
    match 'ie', :page => 'ie'
  end
  
  match 'sublime/video/flash', :to => redirect('http://sublimevideo.net/demo')
  match 'sublime(/:id)', :to => redirect('http://sublimevideo.net')
  
end