class Badge

  attr_accessor :data, :user

  def initialize(data={})
    @data = data
  end

  def name
    @data[:name]
  end

  def rank
    @data[:rank]
  end

  def user
    @user ||= User.new(@data[:user])
  end

  def award_count
    @data[:award_count].to_i
  end

  def badge_type
    @data[:badge_type]
  end

  def to_json
    @data
  end

  def self.fetchTop(options={})
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end

    @@client.get('badges', AppHelper.prepParams) do |result|
      if result.success?
        'TopBadgesFetched'.post_notification(result.object[:items].to_a.map { |q| self.new(q) })
      else
        puts result.error.localizedDescription
      end
    end
  end


end