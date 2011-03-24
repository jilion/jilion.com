class PagesController < ApplicationController
  before_filter :cache_page
  layout :appropriate_layout

  def show
    render params[:page]
  end

protected

  def appropriate_layout
    params[:page] == 'ie' ? false : 'application'
  end

end
