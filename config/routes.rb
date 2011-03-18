Jilion::Application.routes.draw do

  scope :to =>  "pages#show", :via => :get do
    match 'n/:n', :n => /thankyou|confirmed|unsubscribed/, :page => 'home'
    match 'ie', :page => 'ie'
    match 'team', :page => 'team'
    root :page => 'home'
  end

  match 'sublime/video/flash', :to => redirect('http://sublimevideo.net/demo')
  match 'sublime(/:id)',       :to => redirect('http://sublimevideo.net')

  # resources :jobs,     :only => :show
  resources :contacts, :only => :create

  match 'contact', :controller => 'contacts', :action => 'new', :conditions => { :method => :get }, :as => :new_contact
  match 'contacts', :to => redirect('/contact')

  match 'admin', :to => redirect('/admin/contacts')
  namespace :admin do
    # resources :jobs,     :except => :destroy
    resources :contacts, :only => [:index, :show, :update]
  end

end