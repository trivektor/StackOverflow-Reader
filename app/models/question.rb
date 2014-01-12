GRMustacheConfiguration.defaultConfiguration.contentType = GRMustacheContentTypeHTML;

class Question

  include AFNetworkingClient

  attr_accessor :data

  def initialize(data={})
    @data = data
    initAFNetworkingClient
  end

  def id
    @data[:question_id]
  end

  def title
    @data[:title]
  end

  def tags
    @data[:tags]
  end

  def fetchAnswers
    AFMotion::Client.shared.get("questions/#{id}/answers", site: STACK_OVERFLOW_SITE_PARAM, filter: 'withbody') do |result|
      'AnswersFetched'.post_notification(result.object[:items].to_a.map { |a| Answer.new(a) })
    end
  end

  def self.top(options={})
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end
    @@client.get('questions', site: STACK_OVERFLOW_SITE_PARAM) do |result|
      'TopQuestionsFetched'.post_notification(result.object[:items].map { |q| self.new(q) })
    end
  end

  def to_json
    @data
  end

end