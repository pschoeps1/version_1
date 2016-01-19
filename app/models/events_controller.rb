class Api::V1::EventsController < ApplicationController
  
  
  def show
    #finds a group and all associated events
     @group = Group.find(params[:group_id])
     @event = @group.events.find(params[:id])
     if @event.end_at
       @event_end = @event.end_at.strftime("%Y-%m-%dT%H:%M")
     else
       @event_end = nil
     end
  end

  def index
    @user = User.find_by_auth_token(params[:auth_token])
    if @user
      @group = Group.find(params[:group_id])
      @events = @group.events
      render :json=> { :events => @events }
    else 
      #revoke access
    end
  end
  
  
  
 
 
  
  def new
    #finds group and builds event for creating new events
    @group = Group.find(params[:group_id])
    @event = @group.events.build
  end
  
  def update
    #finds an event and updates it attributes.  Relevant code located in event/show page nested inside a modal.
    @group = Group.find(params[:group_id])
    @event = @group.events.find(params[:id]).update_attributes(event_params)
      respond_to do |format|
        format.html  { redirect_to group_path(@group) }
        flash[:success] =  "Event Updated"
     #   format.js
    end
  end
  
  def destroy
    #destroys an event
    @event = Event.find(params[:id]).destroy
    if @event.destroy
      redirect_to group_path(Group.find(params[:group_id]))
    end
  end
  
  def create
      @group = Group.find(params[:group_id])
      @event = @group.events.build(event_params)
      if @event.save
        redirect_to group_path(@group)
        flash[:success] =  "Event Created"
      else
        render 'new'
      end
  end

  private

  def event_params
        params.require(:event).permit(:name, :email, :start_at,
                                     :end_at, :content, :file)
  end
end

