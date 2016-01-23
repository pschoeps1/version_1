class Api::V1::EventsController < ApplicationController
	respond_to :html, :json
  
  def create
  	@user = User.find_by_auth_token(params[:auth_token])

  	if @user
      @group = Group.find(params[:group_id])
      @event = @group.events.build
      @event.name = params[:name]
      @event.start_at = params[:start_at]
      @event.end_at = params[:end_at]
      @event.content = params[:content]

      if @event.save
        render :json => { :success => true }
	  else
		render :json => { :success => false }, :status=>401
	  end
	else
		#permission denied
	end
  end

  private

  
end