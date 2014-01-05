class MenuCell < UITableViewCell
  include AppHelper

  attr_accessor :iconLabel

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    whiteColor = UIColor.whiteColor
    clearColor = UIColor.clearColor

    @iconLabel = UILabel.alloc.initWithFrame([[15, 9], [25, 25]])
    @iconLabel.textColor = whiteColor
    @iconLabel.backgroundColor = clearColor
    @iconLabel.font = FontAwesome.fontWithSize(16)

    @textLabel = UILabel.alloc.initWithFrame([[45, 11], [243, 21]])
    @textLabel.textColor = whiteColor
    @textLabel.backgroundColor = clearColor
    @textLabel.font = 'Helvetica-Neue Light'.uifont(13)

    contentView.addSubview(@iconLabel)
    contentView.addSubview(@textLabel)
    selectedBackgroundView = UIView.alloc.initWithFrame(self.frame)
    selectedBackgroundView.backgroundColor = 'red'.uicolor
    self.selectedBackgroundView = selectedBackgroundView
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
      bottomBorder.backgroundColor = '#fff'.uicolor(0.5)
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
    @table = createTable(cell: MenuCell)
    clearColor = UIColor.clearColor
    @table.backgroundColor = clearColor
    @table.separatorColor = clearColor
    view.backgroundColor = '#3498db'.uicolor
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