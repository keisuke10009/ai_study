require 'faraday_middleware'
require 'openai'

# ChatGTPにプロンプトを送信しレスポンスを取得する
# OPENAI_API_KEYは環境変数から取得
class ChatGptService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  end

  def ask(prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }]
      }
    )
    
    response.dig("choices", 0, "message", "content")
  end
end
