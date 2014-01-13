class TagsController < BaseController

  def init
    super
    @tags = []
    self
  end

  private

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    Tag.top
  end

  def performHousekeepingTasks
    super
    navigationItem.title = 'Tags'
    @table = createTable(cell: QuestionCell)
    view.addSubview(@table)
  end

  def registerEvents
    'TagsFetched'.add_observer(self, 'displayTags:')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @tags.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      QuestionCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    tag = @tags[indexPath.row]

    cell.textLabel.text = "#{tag.name} (#{tag.formatted_count})"
    cell.textLabel.font = 'HelveticaNeue-Light'.uifont(14)
    cell
  end

  def displayTags(notification)
    @tags = notification.object
    @table.reloadData
  end

end