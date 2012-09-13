require 'spec_helper'

describe JobsController do

  it { get('/jobs').should route_to('jobs#index') }
  it { get('/jobs/1').should route_to('jobs#show', id: '1') }

end
