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

  	if @user
      @group = Group.find(params[:group_id])
      @event = @group.events.build
      @event.name = params[:name]
      @event.start_at = params[:start_at]

      end_at_formatted = DateTime.parse(params[:end_at]).strftime('%Q')
      start_at_formatted = DateTime.parse(params[:start_at]).strftime('%Q')

      #sets the end date to that same as the start date if the end date is before the start date (meaning the user did not enter a start date)
      if end_at_formatted <= start_at_formatted
        @event.end_at = params[:start_at]
      else
        @event.end_at = params[:end_at]
      end

      @event.content = params[:content]

      if @event.save
        render :json => { :success => true }
        #push_event(@event, @group, @user)
	    else
		    render :json => { :success => false }, :status=>401
	    end
	else
		#permission denied
	end
  end

  def edit
    @user = User.find_by_auth_token(params[:auth_token])
    #lets make this official as soon as the next update of iOS
    event = Event.find(params[:id])
    event.name = params[:group_name]
    event.name = params[:name]
    event.start_at = params[:start_at]


    end_at_formatted = DateTime.parse(params[:end_at]).strftime('%Q')
    start_at_formatted = DateTime.parse(params[:start_at]).strftime('%Q')

    #sets the end date to that same as the start date if the end date is before the start date (meaning the user did not enter a start date)
    if end_at_formatted <= start_at_formatted
      event.end_at = params[:start_at]
    else
      event.end_at = params[:end_at]
    end


    event.content = params[:content]
    event.save

      if event.save
        render :json => { :success => true }
      else
        render :json => { :success => false }, :status=>401
      end
  end

  def destroy
    user = User.find_by_auth_token(params[:auth_token])
    event = Event.find(params[:id])
    if user
      event.destroy
    end

    if event.destroy
      render :json => { :success => true }
    else
      render :json => { :success => false }, :status=>401
    end
  end

  #def push_event(event, group, user)
  #  users = @group.followers
  #  users.each do |follower|
   #   Notification.create(  
    #        alert:     "#{user.username} created the event #{event.name} in #{group.name} at #{@time}",
     #       recipient: follower
      #    ) 
    #end
  #end

  
end