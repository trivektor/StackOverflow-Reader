class Question

  attr_accessor :data

  def initialize(data={})
    self.data = data
  end

  def self.top(options={})
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header "Accept", "application/json"
      response_serializer :json
    end
    @@client.get('questions', site: STACK_OVERFLOW_SITE_PARAM) do |result|
      'TopQuestionsFetched'.post_notification(result.object.map { |q| self.new(q) })
    end
  end

end