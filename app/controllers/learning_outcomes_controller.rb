class LearningOutcomesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :show]
    # 学習画面
    def new
      @document = Document.find(params[:id])
      @vocabularys = @document.vocabulary.split(",")
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
      
      @learning_outcome = LearningOutcome.new(learning_outcome_params)
      if @learning_outcome.save
        # ポイントを10ポイント付与
        user = current_user
        new_points = current_user.points + 10
        current_user.update_column(:points, new_points)
        redirect_to learning_outcome_path(@learning_outcome.id)
      else
        redirect_to new_learning_outcome_path, status: :unprocessable_entity
      end
    end
  
    # 学習結果画面
    def show
      @learning_outcome = LearningOutcome.find(params[:id])
      @document = Document.find(@learning_outcome.document_id)
      # assessmentから良い点のみを取得
      @good_points = good_from_assessment(@learning_outcome.assessment)
      # assessmentから指摘ポイントを取得
      @improvement_points = improvement_from_assessment(@learning_outcome.assessment)
      # コメントを取得
      @comment = Comment.new
      @comments = @learning_outcome.comments.includes(:user)
    end
  
    private
    
    def learning_outcome_params
      params.require(:learning_outcome).permit(:document_id, :sum_rel_id, :text).merge(user_id: current_user.id, score: @score, assessment: @assessment)
    end
  
    # プロンプトを作りChatGPTに送信する
    def assess(document, text, sum_rel)
      prompt = "#{document}の#{sum_rel}は以下になります。#{text}を【点数】XX点、【良い点】3つ、【改善点】3つの形式で評価してください。"
             + " 【点数】には0〜100点の範囲で採点し、【良い点】と【改善点】は、簡潔で具体的にそれぞれ3つずつ挙げてください。"
      
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
  
    # アセスメントから良い点を取得
    def good_from_assessment(assessment)
      assessments = assessment.split("【改善点】")
      assessment_array(assessments[0].sub("【良い点】", ""))
    end
  
    # アセスメントから改善点を取得
    def improvement_from_assessment(assessment)
      assessments = assessment.split("【改善点】")
      assessment_array(assessments[1].sub("【改善点】", ""))
    end
  
    # 良い点や改善点を配列にするメソッド
    def assessment_array(str)
      str_array = []
      str_line = str.sub("\n", "")
      str_line = str
      str_1 = str_line.split("2.")[0].sub("1.", "")
      str_2 = str_line.split("2.")[1].split("3.")[0].sub("2.", "")
      str_3 = str_line.split("2.")[1].split("3.")[1]
      str_array.push(str_1.delete(" "))
      str_array.push(str_2.delete(" "))
      str_array.push(str_3.delete(" "))
      str_array
    end    
end
