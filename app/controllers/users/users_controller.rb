class UserCell < UITableViewCell

  attr_accessor :user, :avatar, :nameLabel, :locationLabel, :reputationLabel

  CELL_SPACING = 8
  LEFT_PADDING = 64
  TEXT_WIDTH = 270
  HEIGHT = 60

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    @avatar = UIImageView.alloc.initWithFrame([[10, 8], [44, 44]])
    contentView.addSubview(@avatar)

    @nameLabel = UILabel.alloc.initWithFrame([[LEFT_PADDING, 8], [TEXT_WIDTH, 14]])
    @nameLabel.font = 'HelveticaNeue'.uifont(14)
    contentView.addSubview(@nameLabel)

    @locationLabel = UILabel.alloc.initWithFrame([[LEFT_PADDING, 26], [TEXT_WIDTH, 13]])
    @locationLabel.font = 'HelveticaNeue-Light'.uifont(10)
    @locationLabel.textColor = '#999'.uicolor
    contentView.addSubview(@locationLabel)

    @reputationLabel = UILabel.alloc.initWithFrame([[LEFT_PADDING, 41], [TEXT_WIDTH, 12]])
    @reputationLabel.font = 'HelveticaNeue-Light'.uifont(9)
    contentView.addSubview(@reputationLabel)
  end

  def render
    @avatar.setImageWithURL(@user.avatar_nsurl, placeholderImage: nil)
    @nameLabel.text = @user.display_name
    @locationLabel.text = @user.location
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