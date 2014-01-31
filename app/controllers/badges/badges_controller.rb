class BadgesController < BaseController

  def init
    super
    @badges = []
    self
  end

  private

  def viewDidLoad
    super
    navigationItem.title = 'Popular Badges'
    performHousekeepingTasks
    registerEvents
    Badge.fetchTop
    showProgress
  end

  def performHousekeepingTasks
    @table = createTable
    view.addSubview(@table)
    initAMScrollingNavbar
  end

  def registerEvents
    'TopBadgesFetched'.add_observer(self, 'displayBadges:')
  end

  def numberOfSectionInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @badges.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell') || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    badge = tableView(tableView, badgeForRowAtIndexPath: indexPath)

    cell.textLabel.text = "#{badge.name} (#{AppHelper.numberWithComma(badge.award_count)} awarded)"
    cell.textLabel.font = 'HelveticaNeue-Light'.uifont(14)
    cell
  end

  def tableView(tableView, didSelectCellForRowAtIndexPath: indexPath)
    badge = tableView(tableView, badgeForRowAtIndexPath: indexPath)
  end

  def tableView(tableView, badgeForRowAtIndexPath: indexPath)
    @badges[indexPath.row]
  end

  def displayBadges(notification)
    @badges = notification.object
    @table.reloadData
    hideProgress
  end

end