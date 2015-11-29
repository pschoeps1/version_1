class Api::V1::PostsController < ApplicationController
    respond_to :json
    
    def index
        @posts = Post.all
        render json: { posts: @posts }
    end
    
    def post_params
      params.require(:post).permit(:post, :title)
    end

    def show
      @posts = Post.where(:group_id => params[:group_id])
      render json: { posts: @posts}
    end
end
