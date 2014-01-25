class UITableViewCell
  def self.reuseIdentifier
    self.class.to_s
  end

  def defineAccessoryType(type=UITableViewCellAccessoryDisclosureIndicator)
    self.accessoryType = type
  end
end

class QuestionCell < UITableViewCell

  attr_accessor :question, :titleLabel, :subTitleLabel

  CELL_SPACING = 8
  MAX_WIDTH = 276

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
  end

  def render
    contentView.subviews.each { |v| v.removeFromSuperview }
    maximumLabelSize = CGSizeMake(MAX_WIDTH, CGFLOAT_MAX)

    titleLabelHeight = question.title.sizeWithFont('HelveticaNeue'.uifont(14), constrainedToSize: maximumLabelSize).height
    @titleLabel = UILabel.alloc.initWithFrame([[11, CELL_SPACING], [MAX_WIDTH, titleLabelHeight]])
    @titleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @titleLabel.text = AppHelper.decodeHTMLEntities(@question.title)
    @titleLabel.numberOfLines = 0
    @titleLabel.font = 'HelveticaNeue-Light'.uifont(14)
    @titleLabel.sizeToFit

    self.contentView.addSubview(@titleLabel)

    subTitleLabelHeight = question.tags.join(', ').sizeWithFont('HelveticaNeue-Light'.uifont(13), constrainedToSize: maximumLabelSize).height
    @subTitleLabel = UILabel.alloc.initWithFrame([[11, @titleLabel.frame.size.height + CELL_SPACING*3/2], [MAX_WIDTH, subTitleLabelHeight + CELL_SPACING]])
    @subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @subTitleLabel.text = AppHelper.decodeHTMLEntities(@question.tags.join(', '))
    @subTitleLabel.numberOfLines = 0
    @subTitleLabel.font = 'HelveticaNeue-Light'.uifont(13)
    @subTitleLabel.textColor = '#999'.uicolor
    @subTitleLabel.sizeToFit

    contentView.addSubview(@subTitleLabel)
    defineAccessoryType
  end

end

class QuestionsController < BaseController

  def init
    super
    @questions = []
    self
  end

  private

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    Question.top
  end

  def performHousekeepingTasks
    super
    @table = createTable(cell: QuestionCell)
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'search', color: UIColor.whiteColor, touchHandler: 'search')
    view.addSubview(@table)
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

  def sizeOfLabel(label, withText: text)
    text.sizeWithFont(label.font, constrainedToSize:label.frame.size, lineBreakMode:label.lineBreakMode)
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    # Calculate title label height
    question = questionAtIndexPath(indexPath)
    maximumLabelSize = CGSizeMake(QuestionCell::MAX_WIDTH, CGFLOAT_MAX)
    expectedLabelSize1 = AppHelper.decodeHTMLEntities(question.title).sizeWithFont('HelveticaNeue'.uifont(14), constrainedToSize: maximumLabelSize)
    expectedLabelSize2 = AppHelper.decodeHTMLEntities(question.tags.join(', ')).sizeWithFont('HelveticaNeue-Light'.uifont(13), constrainedToSize: maximumLabelSize)
    [QuestionCell::CELL_SPACING, expectedLabelSize1.height, QuestionCell::CELL_SPACING, expectedLabelSize2.height, QuestionCell::CELL_SPACING/2].reduce(:+)
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(QuestionCell.reuseIdentifier) || begin
      QuestionCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: QuestionCell.reuseIdentifier)
    end

    cell.question = @questions[indexPath.row]
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    questionController = QuestionController.alloc.initWithQuestion(questionAtIndexPath(indexPath))
    navigationController.pushViewController(questionController, animated: true)
  end

  private

  def questionAtIndexPath(indexPath)
    @questions[indexPath.row]
  end

  def displayQuestions(notification)
    @questions = notification.object
    @table.reloadData
  end

  def showMenu
    self.sideMenuViewController.presentMenuViewController
  end

  def search
    controller = QuestionsSearchController.new
    navigationController.pushViewController(controller, animated: true)
  end

end

class TopQuestionsController < QuestionsController

  def viewDidLoad
    super
    navigationItem.title = 'Top Questions'
  end

end

class QuestionsSearchController < UIViewController

  include UIViewControllerExtension

  def init
    super
    @results = []
    self
  end

  private

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    navigationItem.title = 'Search'
    createSearchBar
    size = view.bounds.size
    @table = createTable(frame: [[0, 44], [size.width, size.height - 44]])
    view.addSubview(@table)
  end

  def createSearchBar
    @searchBar = UISearchBar.alloc.initWithFrame([[0, 0], [1024, 44]])
    @searchBar.tintColor = '#fff'.uicolor
    @searchBar.backgroundColor = '#fff'.uicolor
    @searchBar.delegate = self
    @searchBar.placeholder = 'Search'
    view.addSubview(@searchBar)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @results.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    nil
  end

end

class TagQuestionsController < QuestionsController

  def initWithTag(tag)
    @tag = tag
    @questions = []
    self
  end

  def viewDidLoad
    super
    navigationItem.title = @tag.name
    registerEvents
    @tag.fetch_questions
  end

  def registerEvents
    'QuestionsByTagFetched'.add_observer(self, 'displayQuestions:')
  end

  def numberOfRowsInSection
    @questions.count
  end

end