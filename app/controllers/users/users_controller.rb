class UserCell < UITableViewCell

  attr_accessor :user, :avatar, :nameLabel, :locationLabel, :reputationLabel

  CELL_SPACING = 8

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    font = 'HelveticaNeue-Light'.uifont(14)

    @avatar = UIImageView.alloc.initWithFrame([[10, 8], [36, 36]])
    contentView.addSubview(@avatar)

    @nameLabel = UILabel.alloc.initWithFrame([[58, 8], [270, 14]])
    @nameLabel.font = font
    contentView.addSubview(@nameLabel)

    @locationLabel = UILabel.alloc.initWithFrame([[58, 30], [270, 11]])
    @locationLabel.font = 'HelveticaNeue-Light'.uifont(11)
    @locationLabel.textColor = '#aaa'.uicolor
    contentView.addSubview(@locationLabel)

    @reputationLabel = UILabel.alloc.initWithFrame([[58, 46], [270, 14]])
    @reputationLabel.font = 'HelveticaNeue-Light'.uifont(11)
    contentView.addSubview(@reputationLabel)
  end

  def render
    @avatar.setImageWithURL(@user.avatar_nsurl, placeholderImage: nil)
    @nameLabel.text = @user.display_name
    @locationLabel.text = @user.location
    @reputationLabel.text = @user.reputation.to_s
    defineAccessoryType
  end

  def self.height
    70
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
  end

end