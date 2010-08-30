Jilion::Application.routes.draw do
  
  root :to => "pages#home"
  
  match 'n/:n', :to => 'pages#home', :via => :get, :n => /thankyou|confirmed|unsubscribed/
  match 'ie', :to => 'pages#ie'
  
  match 'sublime/video/flash', :to => redirect('http://sublimevideo.net/demo')
  match 'sublime*', :to => redirect('http://sublimevideo.net')
  
end