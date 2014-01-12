class MenuCell < UITableViewCell
  include AppHelper

  attr_accessor :iconLabel

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    blackColor = UIColor.blackColor
    clearColor = UIColor.clearColor
    shadowColor = '#000'.uicolor(0.1)
    shadowOffset = CGSizeMake(1, 1)

    @iconLabel = UILabel.alloc.initWithFrame([[15, 9], [25, 25]])
    @iconLabel.textColor = blackColor
    @iconLabel.backgroundColor = clearColor
    @iconLabel.font = FontAwesome.fontWithSize(16)
    @iconLabel.shadowColor = shadowColor
    @iconLabel.shadowOffset = shadowOffset

    @textLabel = UILabel.alloc.initWithFrame([[45, 11], [243, 21]])
    @textLabel.textColor = blackColor
    @textLabel.backgroundColor = clearColor
    @textLabel.font = 'Helvetica-Neue Light'.uifont(13)
    @textLabel.shadowColor = shadowColor
    @textLabel.shadowOffset = shadowOffset

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
      bottomBorder = UIView.alloc.initWithFrame([[0, 43], [180, 0.5]])
      bottomBorder.backgroundColor = '#fff'.uicolor(0.2)
      contentView.addSubview(bottomBorder)
    end
  end

end

class MenuController < UIViewController

  include UIViewControllerExtension
  include AppHelper

  def viewDidLoad
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    frame = self.view.frame
    @table = createTable(cell: MenuCell, frame: CGRectMake(0, 80, frame.size.width, frame.size.height))
    clearColor = UIColor.clearColor
    @table.backgroundColor = clearColor
    @table.separatorColor = clearColor
    view.backgroundColor = '#fff'.uicolor
    view.addSubview(@table)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    5
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(MenuCell.reuseIdentifier) || begin
      MenuCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: MenuCell.reuseIdentifier)
    end

    cell.renderForRowAtIndexPath(indexPath)
    cell
  end

end