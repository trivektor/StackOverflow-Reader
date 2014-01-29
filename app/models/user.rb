class User

  include AFNetworkingClient

  attr_accessor :data, :questions, :tags, :badges

  def initialize(data={})
    @data = data
    @questions = []
    @tags = []
    @badges = []
    initAFNetworkingClient
  end

  def account_id
    @data[:account_id]
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

  def age
    @data[:age]
  end

  def reputation
    @data[:reputation].to_i
  end

  def formatted_reputation
    reputation < 1000 ? reputation : reputation.string_with_style
  end

  def accept_rate
    @data[:accept_rate]
  end

  def website_url
    @data[:website_url]
  end

  def member_for

  end

  def to_json
    @data.merge(
      formatted_reputation: formatted_reputation
    )
  end

  def fetchQuestions(options={})
    AFMotion::Client.shared.get("/users/#{account_id}/questions", AppHelper.prepParams) do |result|
      if result.success?
        @questions += result.object[:items].to_a.map { |q| Question.new(q) }
        'ProfileQuestionsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchTags(options={})
    AFMotion::Client.shared.get("/users/#{account_id}/tags", AppHelper.prepParams) do |result|
      if result.success?
        @tags += result.object[:items].to_a.map { |t| Tag.new(t) }
        'ProfileTagsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchBadges(options={})
    AFMotion::Client.shared.get("/users/#{account_id}/badges", AppHelper.prepParams) do |result|
      if result.success?
        @badges += result.object[:items].to_a.map { |b| Badge.new(b) }
        'ProfileBadgesFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def self.buildClient
    @@client ||= AFMotion::Client.build(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end
  end

  def self.fetchMe(options={})
    return unless AppHelper.access_token
    buildClient
    @@client.get('me', AppHelper.prepParams) do |result|
      if result.success?
        return unless result.object[:items].is_a?(Array) && result.object[:items].length > 0
        data = result.object[:items].to_a.first
        CurrentUserManager.initWithUser(User.new(data))
        'MyselfFetched'.post_notification(CurrentUserManager.sharedInstance)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def self.fetchUsers(options={})
    buildClient
    @@client.get('users', AppHelper.prepParams(options)) do |result|
      if result.success?
        'UsersFetched'.post_notification(result.object[:items].to_a.map { |u| User.new(u) })
      else
        puts result.error.localizedDescription
      end
    end
  end

end