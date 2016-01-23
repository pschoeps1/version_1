class Api::V1::EventsController < ApplicationController
	respond_to :html, :json
  
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

  def event_params
        params.require(:event).permit(:name, :email, :start_at,
                                     :end_at, :content, :file)
  end
end