class DocumentsController < ApplicationController
  
  # 問題文一覧画面
  def index
    # 問題文を取得
    @documents = Document.order(:level_id, :category_id)
    # ログインユーザーの学習結果を取得
    @learning_outcomes = LearningOutcome.where(user_id: current_user.id)
  end

  # 学習画面
  def new
    @document = Document.find(params[:id])
    @learning_outcome = LearningOutcome.new
    @sum_rel_id = params[:sum_rel_id]
  end

  # 学習結果作成
  def create
    @document = Document.find(learning_outcome_params[:document_id])
    # ChatGPTのレスポンスを取得
    response = assess(@document.document, learning_outcome_params[:text], learning_outcome_params[:sum_rel_id])
    @score = score_from_response(response)
    @assessment = assessment_from_resonse(response)
    binding.pry
    
    @learning_outcome = LearningOutcome.new(learning_outcome_params)
    if @learning_outcome.save
      redirect_to document_path(@learning_outcome.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 学習結果画面
  def show
    @learning_outcome = LearningOutcome.find(params[:id])
    @document = Document.find(@learning_outcome.document_id)
    
  end

  private
  
  def learning_outcome_params
    params.require(:learning_outcome).permit(:document_id, :sum_rel_id, :text).merge(user_id: current_user.id, score: @score, assessment: @assessment)
  end

  # プロンプトを作りChatGPTに送信する
  def assess(document, text, sum_rel)
    prompt = "#{document}の#{sum_rel}は以下になります。#{text}を【点数】XX点、【良い点】3つ、【指摘ポイント】3つの形式で評価してください。"
           + " 【点数】には0〜100点の範囲で採点し、【良い点】と【指摘ポイント】は、簡潔で具体的にそれぞれ3つずつ挙げてください。"
    
    chat_service = ChatGptService.new
    response = chat_service.ask(prompt)
  end

  # レスポンスから点数だけ取得する
  def score_from_response(response)
    match = response.match(/(?<=【点数】)\d+(?=点)/)
    if match
      match[0].to_i
    else
      return 0
    end
  end
  
  # レスポンスから【良い点】以降を取得する
  def assessment_from_resonse(response)
    response[/(【良い点】.*)/m, 1]
  end
end
