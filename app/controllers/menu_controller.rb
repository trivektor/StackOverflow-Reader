class MenuCell < UITableViewCell

  HEIGHT = 54

  attr_accessor :iconLabel, :textLabel, :image

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    whiteColor = '#fff'.uicolor
    clearColor = UIColor.clearColor

    @iconLabel = UILabel.alloc.initWithFrame([[15, 14], [25, 25]])
    @iconLabel.textColor = whiteColor
    @iconLabel.backgroundColor = clearColor
    @iconLabel.font = FontAwesome.fontWithSize(17)

    @textLabel = UILabel.alloc.initWithFrame([[45, 16], [243, 21]])
    @textLabel.textColor = whiteColor
    @textLabel.backgroundColor = clearColor
    @textLabel.font = 'HelveticaNeue-Light'.uifont(16)

    contentView.addSubview(@iconLabel)
    contentView.addSubview(@textLabel)
    selectedBackgroundView = UIView.alloc.initWithFrame(self.frame)
    selectedBackgroundView.backgroundColor = 'red'.uicolor
    self.selectedBackgroundView = selectedBackgroundView
    self.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def renderForRowAtIndexPath(indexPath)
    self.backgroundColor = UIColor.clearColor
    case indexPath.row
    when -1
      if CurrentUserManager.sharedInstance
        @image = UIImageView.alloc.initWithFrame([[15, 9], [26, 26]])

        contentView.addSubview(@image)

        currentUser = CurrentUserManager.sharedInstance
        userImageData = NSData.dataWithContentsOfURL(currentUser.profile_image.nsurl)
        @image.image = UIImage.imageWithData(userImageData)
        @image.layer.masksToBounds = true
        @image.layer.cornerRadius = 3
        @textLabel.text = currentUser.display_name
      else
        @textLabel.text = 'Login'
        @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-lock')
      end
    when 0
      @textLabel.text = 'Questions'
      @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-question')
    when 1
      @textLabel.text = 'Tags'
      @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-tags')
    when 2
      @textLabel.text = 'Users'
      @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-user')
    when 3
      @textLabel.text = 'Badges'
      @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-flag')
    when 4
      @textLabel.text = 'Unanswered'
      @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-bolt')
    end

    if indexPath.row < 4
      bottomBorder = UIView.alloc.initWithFrame([[0, 53], [180, 0.5]])
      bottomBorder.backgroundColor = '#fff'.uicolor(0.1)
      contentView.addSubview(bottomBorder)
    end
  end

end

class MenuController < UIViewController

  include UIViewControllerExtension

  private

  def viewDidLoad
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    frame = self.view.frame
    clearColor = UIColor.clearColor
    @table = createTable(cell: MenuCell, frame: CGRectMake(0, 80, frame.size.width, frame.size.height), background_color: clearColor, separator_color: clearColor)
    view.backgroundColor = '#222'.uicolor
    view.addSubview(@table)
  end

  def registerEvents
    'PostLoginReload'.add_observer(self, 'reloadAfterLogin')
    'MyselfFetched'.add_observer(self, 'reloadAfterLogin')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    5
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    MenuCell::HEIGHT
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(MenuCell.reuseIdentifier) || begin
      MenuCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: MenuCell.reuseIdentifier)
    end

    cell.renderForRowAtIndexPath(indexPath)
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    case indexPath.row
    when -1
      return if AppHelper.access_token
      sideMenuViewController.hideMenuViewController
      controller = UINavigationController.alloc.initWithRootViewController(LoginController.new)
      controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical
      presentModalViewController(controller, animated: true)
    when 0
      navigateToSelectedController(UINavigationController.alloc.initWithRootViewController(TopQuestionsController.new))
    when 1
      navigateToSelectedController(UINavigationController.alloc.initWithRootViewController(TagsController.new))
    when 2
      navigateToSelectedController(UINavigationController.alloc.initWithRootViewController(UsersController.new))
    end
  end

  def navigateToSelectedController(controller)
    sideMenuViewController.setContentViewController(controller)
    sideMenuViewController.hideMenuViewController
  end

  def reloadAfterLogin
    @table.reloadData
  end

end