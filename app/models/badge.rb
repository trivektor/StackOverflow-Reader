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

end