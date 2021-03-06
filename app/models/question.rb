class Question

  include AFNetworkingClient

  attr_accessor :data

  SEARCH_PARAMS = [
    :tagged,
    :intitle
  ]

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
    AFMotion::Client.shared.get("questions/#{id}/answers", AppHelper.prepParams(filter: 'withbody')) do |result|
      if result.success?
        'AnswersFetched'.post_notification(result.object[:items].to_a.map { |a| Answer.new(a) })
      else
        puts result.error.localizedDescription
      end
    end
  end

  def self.top(options={})
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end

    @@client.get('questions', AppHelper.prepParams(filter: 'withbody')) do |result|
      if result.success?
        'TopQuestionsFetched'.post_notification(result.object[:items].to_a.map { |q| self.new(q) })
      else
        puts result.error.localizedDescription
      end
    end
  end

  def self.search(options={})
    params = AppHelper.prepParams
    SEARCH_PARAMS.each { |p| params.merge!({p => options[p]}) if options[p] }

    AFMotion::Client.shared.get('search', params) do |result|
      if result.success?
        'QuestionsFetched'.post_notification(result.object[:items].to_a.map { |q| self.new(q) })
      else
        puts result.error.localizedDescription
      end
    end
  end

  def to_json
    @data.merge(owner: owner.to_json)
  end

end