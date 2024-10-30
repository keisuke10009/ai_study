require 'faraday_middleware'
require 'openai'

class ChatGptService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  end

  def ask(prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # または "gpt-4"などの利用可能なモデル名
        messages: [{ role: "user", content: prompt }]
      }
    )
    
    response.dig("choices", 0, "message", "content")
  end
end
