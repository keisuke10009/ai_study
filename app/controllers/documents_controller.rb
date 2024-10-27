class DocumentsController < ApplicationController
  
  def index
    # 問題文を取得
    @documents = Document.order(:level_id, :category_id)
    # ログインユーザーの学習結果を取得
    @learning_outcomes = LearningOutcome.where(user_id: current_user.id)
  end

  def new
    @document = Document.find_by(id: params[:id])
    @learning_outcome = LearningOutcome.new
    @learning_outcome.sum_rel_id = params[:sum_rel_id]
  end

end
