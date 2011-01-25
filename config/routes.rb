Jilion::Application.routes.draw do

  scope to: "pages#show", via: :get do
    root page: 'home'
    match 'n/:n', as: :page, n: /thankyou|confirmed|unsubscribed/, page: 'home'
    match 'ie', page: 'ie'
  end

  match 'sublime/video/flash', to: redirect('http://sublimevideo.net/demo')
  match 'sublime(/:id)',       to: redirect('http://sublimevideo.net')

  resources :jobs,     only: [:index, :show]
  resources :contacts, only: [:create]
  
  match 'contact', controller: 'contacts', action: 'new', conditions: { method: :get }, as: :new_contact
  match 'contacts', :to => redirect('/contact')
  match "contact/Jilion-contact.pdf", controller: 'contacts', action: 'show', conditions: { method: :get }, as: :contact_pdf

  match 'admin', to: redirect('/admin/contacts')
  namespace :admin do
    resources :jobs,     except: [:destroy]
    resources :contacts, only: [:index, :show, :update]
  end

end