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

  def avatar_nsurl
    avatar.nsurl
  end

  def display_name
    @data[:display_name]
  end

  def location
    @data[:location]
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

  def self.buildClient
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end
  end

  def self.fetchMe(access_token, options={})
    buildClient
    @@client.get('me', site: STACK_OVERFLOW_SITE_PARAM, access_token: AppHelper.getAccessToken, key: STACK_EXCHANGE_KEY) do |result|
      data = result.object[:items].to_a.first
      CurrentUserManager.initWithUser(User.new(data))
      'MyselfFetched'.post_notification(CurrentUserManager.sharedInstance)
    end
  end

  def self.fetchUsers(options={})
    buildClient
    @@client.get('users', {site: STACK_OVERFLOW_SITE_PARAM, access_token: AppHelper.getAccessToken, key: STACK_EXCHANGE_KEY}.merge(options)) do |result|
      if result.success?
        'UsersFetched'.post_notification(result.object[:items].map { |u| User.new(u) })
      else
        puts result.error.localizedDescription
      end
    end
  end

end