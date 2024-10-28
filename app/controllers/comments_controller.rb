class CommentsController < ApplicationController
    def create
    @trail = Trail.find(params[:post_id])
    @comment = @trail.comments.create(params[:comment].permit(:body))
    redirect_to post_path(@trail)
  end
end
