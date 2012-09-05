require 'spec_helper'

describe ContactMailer do
  subject { create(:contact) }

  before do
    subject
    ActionMailer::Base.deliveries.clear
  end

  describe "#notification" do
    before do
      ContactMailer.notification(subject).deliver
      @last_delivery = ActionMailer::Base.deliveries.last
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.size.should == 1
    end

    it "should send the mail from noreply@jilion.com" do
      @last_delivery.from.should == ["noreply@jilion.com"]
    end

    it "should send the mail to mehdi@jilion.com & zeno@jilion.com" do
      @last_delivery.to.should == ["mehdi@jilion.com", "zeno@jilion.com"]
    end

    it "should set content_type to text/plain; charset=UTF-8 (set by default by the Mail gem)" do
      @last_delivery.content_type.should =~ %r{text/plain; charset=UTF-8}
    end

    it "should set subject to Liquidified template.subject" do
      @last_delivery.subject.should == "New contact (#{subject.type_name.humanize}) from #{subject.email}"
    end

    it "should set the body to Liquidified-simple_formated-auto_linked template.body" do
      @last_delivery.body.encoded.should include admin_contact_url(subject)
    end
  end

end
