class Api::V1::InvitesController < ApplicationController
  respond_to :html
   
  def create
     @invite = Invite.new(invite_params) # Make a new Invite
     @invite.sender_id = current_user.id # set the sender to the current user
     @invite.sender_name = current_user.username
     @invite.group_name = @invite.group.name
     if @invite.save
         
        if User.find_by_email(email) != nil
          #check to see if the group owner is trying to invite himself.
          if @invite.sender_id === @invite.group.user_id
              #do nothing
          else
             #send a notification email
             InviteMailer.existing_user_invite(@invite, new_user_session_path).deliver_now 

             #Add the user to the user group
             #check if a relationship exists, and if it does only send an email.
             if @invite.recipient.relationships.exists? followed_id: @invite.group.id || @invite.sender_id == @invite.group.user_id
             else
               @invite.recipient.relationships.create!(followed_id: @invite.group.id)
             end
          end
        else
            
             InviteMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)).deliver_now #send the invite data to our mailer to deliver the email
        end
        
        else
        # oh no, creating an new invitation failed
     end
     render :json => { :success => true }
end
  
  def invite_params
      params.require(:invite).permit(:email, :multiple_invites, :group_id)
  end
    
end