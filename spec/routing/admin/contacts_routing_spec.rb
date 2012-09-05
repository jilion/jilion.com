require 'spec_helper'

describe Admin::ContactsController do

  it { get('/admin/contacts').should route_to('admin/contacts#index') }
  it { get('/admin/contacts/1').should route_to('admin/contacts#show', id: '1') }
  it { put('/admin/contacts/1').should route_to('admin/contacts#update', id: '1') }

end
