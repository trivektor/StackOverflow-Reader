class QuestionsController < UIViewController

  include UIViewControllerExtension

  def init
    super
    @questions = []
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    Question.top
  end

  private

  def performHousekeepingTasks
    @table = createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'TopQuestionsFetched'.add_observer(self, 'displayQuestions:')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @questions.count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    44
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      NewsfeedCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end
    cell
  end

  def displayQuestions(notification)
    @questions = notification.object
  end

end

class TopQuestionsController < QuestionsController

  def viewDidLoad
    super
    self.navigationItem.title = 'Top Questions'
  end

end