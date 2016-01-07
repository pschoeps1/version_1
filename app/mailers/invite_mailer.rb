class InviteMailer < ApplicationMailer
  respond_to :html

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.new_user.subject
  #
  def new_user_invite(invite, invite_url)
    @url = invite_url
    @sender_name = invite.sender_name
    @group_name =invite.group_name

    mail to: invite.email, subject: "#{invite.sender_name} has invited you to join the group #{invite.group_name}!"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.current_user.subject
  #
  def existing_user_invite(invite, invite_url)
    @url = invite_url
    @sender_name = invite.sender_name
    @group_name =invite.group_name

    mail to: invite.email, subject: "#{invite.sender_name} has invited you to join the group #{invite.group_name}!"
  end
end
