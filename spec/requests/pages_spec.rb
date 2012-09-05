# coding: utf-8
require 'spec_helper'

feature "Redirects page" do

  scenario "redirects /jobs to /#jobs" do
    visit '/jobs'
    current_url.should eq "http://jilion.dev/"
  end

  %w[pr press].each do |page|
    scenario "redirects /#{page} to /pr/2011-03-30" do
      visit "/#{page}"
      current_url.should eq "http://jilion.dev/pr/2011-03-30"
    end
  end

  pending "redirects /press/sublimevideo/press-kit to http://cl.ly/0W1z3E1p342T431P2K0z" do
    visit '/press/sublimevideo/press-kit'
    current_url.should eq "http://cl.ly/0W1z3E1p342T431P2K0z"
  end

  pending "redirects /sublime/video/flash to http://sublimevideo.net/features" do
    visit '/sublime/video/flash'
    current_url.should eq "http://sublimevideo.net/features"
  end

  scenario "redirects /sublime to http://sublimevideo.net/" do
    visit '/sublime'
    current_url.should eq "http://sublimevideo.net/"
  end

  scenario "redirects /sublime/foo to http://sublimevideo.net/" do
    visit '/sublime/foo'
    current_url.should eq "http://sublimevideo.net/"
  end

  scenario "redirects /contacts to /contact" do
    visit '/contacts'
    current_url.should eq "http://jilion.dev/contact"
  end

end
