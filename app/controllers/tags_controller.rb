class TagsController < UIViewController

  include UIViewControllerExtension
  
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
  end

  def performHousekeepingTasks
    navigationItem.title = 'Tags'
    @table = createTable(cell: QuestionCell)
    view.addSubview(@table)
  end

  def registerEvents
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @tags.count
  end

end