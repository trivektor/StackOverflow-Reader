class Tag
  include AFNetworkingClient

  attr_accessor :data

  def initialize(data={})
    @data = data
    initAFNetworkingClient
  end

  def count
    @data[:count].to_i
  end

  def name
    @data[:name]
  end

  def fetch_questions
    AFMotion::Client.shared.get('questions', site: STACK_OVERFLOW_SITE_PARAM, tagged: name) do |result|
      'QuestionsByTagFetched'.post_notification(result.object[:items].to_a.map { |q| Question.new(q) })
    end
  end

  def self.fetchTop(options={})
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end

    @@client.get('tags', AppHelper.prepParams(options.merge(filter: 'withbody'))) do |result|
      if result.success?
        'TagsFetched'.post_notification(result.object[:items].to_a.map { |q| self.new(q) })
      else
        puts result.error.localizedDescription
      end
    end
  end

  def to_json(options={})
    @data.merge(formatted_count: formatted_count)
  end

end