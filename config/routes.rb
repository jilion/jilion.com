Jilion::Application.routes.draw do

  get '/n/:n' => 'pages#show', n: /thankyou|confirmed|unsubscribed/, page: 'home'
  get '/ie' => 'pages#show', page: 'ie'
  get '/pr/2011-03-30' => 'pages#show', page: 'press_2011_03_30'
  root to: 'pages#show', page: 'home'

  get '/:p' => redirect('/pr/2011-03-30'), p: /pr|press/ #temporary
  get '/press/sublimevideo/press-kit' => redirect("http://cl.ly/0W1z3E1p342T431P2K0z")

  get '/sublime/video/flash' => redirect('http://sublimevideo.net/features')
  get '/sublime(/:id)'       => redirect('http://sublimevideo.net')

  resources :jobs,     only: [:index, :show]
  resources :contacts, only: :create

  get '/contact' => 'contacts#new', via: 'get', as: :new_contact
  get '/contacts' => redirect('/contact')

  get '/admin' => redirect('/admin/contacts')
  namespace :admin do
    resources :jobs,     except: :destroy
    resources :contacts, only: [:index, :show, :update]
  end

end
