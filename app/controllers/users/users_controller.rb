class UserCell < UITableViewCell

  attr_accessor :user, :avatar, :nameLabel, :locationLabel, :reputationLabel

  CELL_SPACING = 12
  LEFT_PADDING = 64
  TEXT_WIDTH = 270
  HEIGHT = 76
  NAME_FONT = 'HelveticaNeue-Medium'.uifont(16)
  LOCATION_FONT = 'HelveticaNeue-Light'.uifont(14)
  REPUTATION_FONT = 'HelveticaNeue-Light'.uifont(15)

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    @avatar = UIImageView.alloc.initWithFrame([[10, 8], [44, 44]])
    contentView.addSubview(@avatar)

    @nameLabel = UILabel.alloc.initWithFrame([[LEFT_PADDING, 8], [TEXT_WIDTH, 19]])
    @nameLabel.font = NAME_FONT
    contentView.addSubview(@nameLabel)

    @locationLabel = UILabel.alloc.initWithFrame([[LEFT_PADDING, 30], [TEXT_WIDTH, 17]])
    @locationLabel.font = LOCATION_FONT
    @locationLabel.textColor = '#999'.uicolor
    contentView.addSubview(@locationLabel)

    @reputationLabel = UILabel.alloc.initWithFrame([[LEFT_PADDING, 50], [TEXT_WIDTH, 17]])
    @reputationLabel.font = REPUTATION_FONT
    contentView.addSubview(@reputationLabel)
  end

  def render
    @avatar.setImageWithURL(@user.avatar_nsurl, placeholderImage: nil)
    @nameLabel.text = @user.display_name
    @locationLabel.text = AppHelper.decodeHTMLEntities(@user.location || 'Somewhere on Earth')
    @reputationLabel.text = @user.reputation.to_i.string_with_style
    defineAccessoryType
  end

  def self.height
    HEIGHT
  end

end

class UsersController < BaseController

  def init
    super
    @users = []
    self
  end

  private

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    User.fetchUsers(sort: 'reputation', order: 'desc')
    showProgress
  end

  def performHousekeepingTasks
    super
    navigationItem.title = 'Top Users'
    @table = createTable(cell: UserCell)
    view.addSubview(@table)
  end

  def registerEvents
    'UsersFetched'.add_observer(self, 'displayUsers:')
  end

  def numberOfSectionInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @users.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    UserCell.height
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    identifier = UserCell.reuseIdentifier
    cell = @table.dequeueReusableCellWithIdentifier(identifier) || begin
      UserCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: identifier)
    end

    cell.user = @users[indexPath.row]
    cell.render
    cell
  end

  def displayUsers(notification)
    @users = notification.object
    @table.reloadData
    hideProgress
  end

end