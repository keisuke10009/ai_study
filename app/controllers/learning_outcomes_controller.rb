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
      # @score = score_from_response(response)
      # @assessment = assessment_from_resonse(response)
      
      @score = 60
      @assessment = response
      
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
      # @good_points = good_from_assessment(@learning_outcome.assessment)
      # assessmentから指摘ポイントを取得
      # @improvement_points = improvement_from_assessment(@learning_outcome.assessment)
      @assessments = @learning_outcome.assessment
      # コメントを取得
      @comment = Comment.new
      @comments = @learning_outcome.comments.includes(:user)
    end
  
    # 学習履歴画面
    def history
      begin
        # documentsテーブルとlearning_outcomesテーブルから取得
        @documents_learning_outcomes = Document.joins(:learning_outcomes)
                              .where(learning_outcomes: { user_id: current_user.id })
                              .select('documents.level_id, documents.category_id, documents.title, learning_outcomes.sum_rel_id, learning_outcomes.score, learning_outcomes.created_at')
                              .order('learning_outcomes.created_at ASC')
        # 学習回数
        @learnings = @documents_learning_outcomes.length
        
        if @learnings != 0
          # 最高点
          @max = LearningOutcome.where(user_id: current_user.id).maximum(:score)
          # 平均点
          @average = LearningOutcome.where(user_id: current_user.id).average(:score).round
        else
          @max = 0
          @average = 0
        end
      rescue => e
        Rails.logger.debug e.message
      end
    end

    private
    
    def learning_outcome_params
      params.require(:learning_outcome).permit(:document_id, :sum_rel_id, :text).merge(user_id: current_user.id, score: @score, assessment: @assessment)
    end
  
    # プロンプトを作りChatGPTに送信する
    def assess(document, text, sum_rel_id)
      if sum_rel_id == 1
        sum_rel = "要約"
      else
        sum_rel = "感想文"
      end
      # prompt = 'あなたは優秀な国語教師です。' +
      #           '#{document}の#{sum_rel}は以下になります。#{text}を次のフォーマットで回答してください。' +
      #           '【点数】XX点【良い点】1.XXXXXX 2.XXXXX 3.XXXXX【改善点】1.XXXXXX 2.XXXXX 3.XXXXX' +
      #           'XXXXの部分にはあなたの意見を入れて下さい' +
      #           'フォーマット部分(XXXXの部分)は出力しないで結構です'
      
      prompt = 'あなたは優秀な国語教師です。' +
                document + 'の' + sum_rel + 'は以下になります。' + text + '改善点を提示して下さい。'
      
      chat_service = ChatGptService.new
      chat_service.ask(prompt)
      # claude_sevice = ClaudeService.new
      # response = claude_sevice.ask(prompt)
    end
  
    # レスポンスから点数だけ取得する
    def score_from_response(response)
      begin
        match = response.match(/(?<=【点数】)\d+(?=点)/)
        if match
          match[0].to_i
        else
          return 60
        end
      rescue => e
        # Rails.logger.debug e.message
        return 60
      end
    end
    
    # レスポンスから【良い点】以降を取得する
    def assessment_from_resonse(response)
      begin
        response[/(【良い点】.*)/m, 1]
      rescue => e
        # Rails.logger.debug e.message
        return " "
      end
    end
  
    # アセスメントから良い点を取得
    def good_from_assessment(assessment)
      begin
        assessments = assessment.split('【改善点】')
        assessment_array(assessments[0].sub('【良い点】', ''))
      rescue => e
        Rails.logger.debug e.message
        str_array = [""]
      end
    end
  
    # アセスメントから改善点を取得
    def improvement_from_assessment(assessment)
      begin
        assessments = assessment.split('【改善点】')
        assessment_array(assessments[1].sub('【改善点】', ''))
      rescue => e
        Rails.logger.debug e.message
        str_array = [""]
      end
    end
  
    # 良い点や改善点を配列にするメソッド
    # nilクラスのエラー処理が必要
    def assessment_array(str)
      str_array = []
      
      begin
        str_line = str.sub("\n", "")
        str_line = str
        str_1 = str_line.split("2.")[0].sub("1.", "")
        str_2 = str_line.split("2.")[1].split("3.")[0].sub("2.", "")
        str_3 = str_line.split("2.")[1].split("3.")[1]
        str_array.push(str_1.delete(" "))
        str_array.push(str_2.delete(" "))
        str_array.push(str_3.delete(" "))
        str_array
      rescue => e
        Rails.logger.debug e.message
        str_array = [""]
      end
    end    
end
