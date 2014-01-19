class User

  include AFNetworkingClient

  attr_accessor :data

  def initialize(data={})
    @data = data
    initAFNetworkingClient
  end

  def avatar
    @data[:profile_image]
  end

  def display_name
    @data[:display_name]
  end

  def profile_image
    @data[:profile_image]
  end

  def reputation
    @data[:reputation].to_i
  end

  def formatted_reputation
    reputation < 1000 ? reputation : reputation.string_with_style
  end

  def to_json
    @data.merge(
      formatted_reputation: formatted_reputation
    )
  end

  def self.fetchMe(access_token, options={})
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end

    @@client.get('me', site: STACK_OVERFLOW_SITE_PARAM, access_token: access_token, key: STACK_EXCHANGE_KEY) do |result|
      data = result.object[:items].to_a.first
      CurrentUserManager.initWithUser(User.new(data))
      'MyselfFetched'.post_notification(CurrentUserManager.sharedInstance)
    end
  end

end