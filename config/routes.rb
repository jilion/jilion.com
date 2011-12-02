Jilion::Application.routes.draw do

  scope :to =>  "pages#show", :via => :get do
    match 'n/:n', :n => /thankyou|confirmed|unsubscribed/, :page => 'home'
    match 'ie', :page => 'ie'
    match 'team', :page => 'team'
    match 'pr/2011-03-30', :page => 'press_2011_03_30'
    # match 'press/sublimevideo', :page => 'press_sublimevideo'
    root :page => 'home'
  end
  
  # match ':p', :p => /pr|press/, :to => redirect('/press/sublimevideo') #temporary
  match ':p', :p => /pr|press/, :to => redirect('pr/2011-03-30') #temporary
  match "press/sublimevideo/press-kit", :to => redirect("http://cl.ly/0W1z3E1p342T431P2K0z")
  
  match 'sublime/video/flash', :to => redirect('http://sublimevideo.net/demo')
  match 'sublime(/:id)',       :to => redirect('http://sublimevideo.net')

  resources :jobs,     :only => :show
  resources :contacts, :only => :create

  match 'contact', :controller => 'contacts', :action => 'new', :conditions => { :method => :get }, :as => :new_contact
  match 'contacts', :to => redirect('/contact')

  match 'admin', :to => redirect('/admin/contacts')
  namespace :admin do
    resources :jobs,     :except => :destroy
    resources :contacts, :only => [:index, :show, :update]
  end

end