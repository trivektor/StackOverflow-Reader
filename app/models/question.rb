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

  def body
    @data[:body]
  end

  def tags
    @data[:tags]
  end

  def owner
    User.new(@data[:owner])
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
    @@client.get('questions', site: STACK_OVERFLOW_SITE_PARAM, filter: 'withbody', access_token: AppHelper.access_token, key: STACK_EXCHANGE_KEY) do |result|
      'TopQuestionsFetched'.post_notification(result.object[:items].to_a.map { |q| self.new(q) })
    end
  end

  def to_json
    @data.merge(owner: owner.to_json)
  end

end