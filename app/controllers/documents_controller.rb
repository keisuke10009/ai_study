class DocumentsController < ApplicationController
  before_action :authenticate_user!, only: :index
  # 問題文一覧画面
  def index
    # 問題文を取得
    @documents = Document.order(:level_id, :category_id)
    # ログインユーザーの学習結果を取得
    @learning_outcomes = LearningOutcome.where(user_id: current_user.id)
  end

end
