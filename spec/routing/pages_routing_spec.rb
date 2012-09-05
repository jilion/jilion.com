require 'spec_helper'

describe PagesController do

  it { get('/n/thankyou').should route_to('pages#show', page: 'home', n: 'thankyou') }
  it { get('/n/confirmed').should route_to('pages#show', page: 'home', n: 'confirmed') }
  it { get('/n/unsubscribed').should route_to('pages#show', page: 'home', n: 'unsubscribed') }
  it { get('/ie').should route_to('pages#show', page: 'ie') }

end
