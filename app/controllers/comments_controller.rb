class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to learning_outcome_comments_path(@comment.learning_outcome)
    else
      @learning_outcome = @comment.document
      @comments = @learning_outcome.comments
      render "learning_outcomes/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, learning_outcome_id: params[:learning_outcome_id])
  end

end
