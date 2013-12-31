class Question

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def title
    @data[:title]
  end

  def tags
    @data[:tags]
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

end