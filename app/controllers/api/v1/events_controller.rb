class Api::V1::EventsController < ApplicationController
	respond_to :json

  def index
    @user = User.find_by_auth_token(params[:auth_token])
    if @user
      @group = Group.find(params[:group_id])
      @events = @group.events

      render :json => { :events => @events }
    else
      #permission denied
    end
  end
  
  def create
  	@user = User.find_by_auth_token(params[:auth_token])
    puts @user

  	if @user
      @group = Group.find(params[:group_id])
      @event = @group.events.build
      @event.name = params[:name]
      @event.start_at = params[:start_at]
      @event.end_at = params[:end_at]
      @event.content = params[:content]
      puts "in event"

      if @event.save
        render :json => { :success => true }
	    else
		    render :json => { :success => false }, :status=>401
	    end
	else
		#permission denied
	end
  end

  
end