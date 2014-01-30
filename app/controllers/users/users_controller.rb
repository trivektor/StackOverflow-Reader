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
    navigationItem.title = 'Top Users'
    performHousekeepingTasks
    registerEvents
    User.fetchUsers(sort: 'reputation', order: 'desc')
    buildOptionsMenu
    showProgress
  end

  def performHousekeepingTasks
    super
    @table = createTable(cell: UserCell)
    view.addSubview(@table)
    initAMScrollingNavbar
  end

  def orderUsers(sort, options={})
    User.fetchUsers(sort: sort, order: options[:order] || 'desc')
    showProgress
  end

  def buildOptionsMenu
    @reputationOrder = REMenuItem.alloc.initWithTitle('Sort by Reputation', subtitle: nil, image: nil, highlightedImage: nil, action:-> item {
      orderUsers('reputation')
    })
    @creationOrder = REMenuItem.alloc.initWithTitle('Sort by Joined Date', subtitle: nil, image: nil, highlightedImage: nil, action:-> item {
      orderUsers('creation')
    })
    @nameOrder = REMenuItem.alloc.initWithTitle('Sort by Name', subtitle: nil, image: nil, highlightedImage: nil, action:-> item {
      orderUsers('name')
    })
    @modifiedOrder = REMenuItem.alloc.initWithTitle('Sort by Latest Activities', subtitle: nil, image: nil, highlightedImage: nil, action:-> item {
      orderUsers('modified')
    })
    @userSearch = REMenuItem.alloc.initWithTitle('Search User', subtitle: nil, image: nil, highlightedImage: nil, action:-> item {
      @optionsMenu.closeWithCompletion(-> {
        navigationController.pushViewController(UsersSearchController.new, animated: true)
      })
    })
    @optionsMenu = createOptionsMenu([@reputationOrder, @creationOrder, @nameOrder, @modifiedOrder, @userSearch])
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'cog', color: '#fff'.uicolor, touchHandler: 'toggleOptionsMenu')
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

    cell.user = tableView(tableView, userAtIndexPath: indexPath)
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    navigationController.pushViewController(
      UserController.alloc.initWithUser(tableView(tableView, userAtIndexPath: indexPath)),
      animated: true
    )
  end

  def tableView(tableView, userAtIndexPath: indexPath)
    @users[indexPath.row]
  end

  def displayUsers(notification)
    @users = notification.object
    @table.reloadData
    hideProgress
  end

  def toggleOptionsMenu
    return @optionsMenu.close if @optionsMenu.isOpen
    @optionsMenu.showInView(view)
  end

end

class UsersSearchController < UsersController

  def viewDidLoad
    navigationItem.title = 'Search User'
  end

  def performHousekeepingTasks
    super
  end

end