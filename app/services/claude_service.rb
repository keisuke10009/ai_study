require 'faraday_middleware'
require 'anthropic'

class ClaudeService
  def initialize
    @client = Anthropic::Client.new(access_token: ENV.fetch("ANTHROPIC_API_KEY"))
  end

  def ask(prompt)
    # エラーハンドリングを含めた完全な例
    begin
      response = @client.messages.create(
        model: "claude-3-sonnet-20240229",
        messages: [
          { role: "user", content: prompt }
        ]
      )
      assistant_message = response.content.first.text
    rescue Anthropic::Error => e
      # エラーハンドリング
      Rails.logger.error "Claude API Error: #{e.message}"
      # エラー処理
    end
  end
end
