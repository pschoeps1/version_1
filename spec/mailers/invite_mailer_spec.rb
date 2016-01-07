require "spec_helper"

describe InviteMailer do
  describe "new_user_invite" do
    let(:mail) { InviteMailer.new_user_invite }

    it "renders the headers" do
      mail.subject.should eq("New user invite")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "existing_user_invite" do
    let(:mail) { InviteMailer.existing_user_invite }

    it "renders the headers" do
      mail.subject.should eq("Existing user invite")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
