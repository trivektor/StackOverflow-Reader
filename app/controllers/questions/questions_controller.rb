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

  CELL_SPACING = 12
  MAX_WIDTH = 276
  TITLE_FONT = 'HelveticaNeue-Medium'.uifont(16)
  SUB_TITLE_FONT = 'HelveticaNeue-Light'.uifont(15)

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    self
  end

  def render
    contentView.subviews.each { |v| v.removeFromSuperview }
    maximumLabelSize = CGSizeMake(MAX_WIDTH, CGFLOAT_MAX)

    titleLabelHeight = question.title.sizeWithFont(TITLE_FONT, constrainedToSize: maximumLabelSize).height
    @titleLabel = UILabel.alloc.initWithFrame([[11, CELL_SPACING], [MAX_WIDTH, titleLabelHeight]])
    @titleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @titleLabel.text = AppHelper.decodeHTMLEntities(@question.title)
    @titleLabel.numberOfLines = 0
    @titleLabel.font = TITLE_FONT
    @titleLabel.sizeToFit

    self.contentView.addSubview(@titleLabel)

    tags = question.tags.join(', ')
    subTitleLabelHeight = tags.sizeWithFont(SUB_TITLE_FONT, constrainedToSize: maximumLabelSize).height
    @subTitleLabel = UILabel.alloc.initWithFrame([[11, @titleLabel.frame.size.height + CELL_SPACING*3/2], [MAX_WIDTH, subTitleLabelHeight + CELL_SPACING]])
    @subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @subTitleLabel.text = AppHelper.decodeHTMLEntities(tags)
    @subTitleLabel.numberOfLines = 0
    @subTitleLabel.font = SUB_TITLE_FONT
    @subTitleLabel.textColor = '#999'.uicolor
    @subTitleLabel.sizeToFit

    contentView.addSubview(@subTitleLabel)
    defineAccessoryType
  end

end

class QuestionsController < BaseController

  include UIViewControllerExtension

  def init
    super
    @questions = []
    self
  end

  protected

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    super
    @table = createTable(cell: QuestionCell)
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'search', color: UIColor.whiteColor, touchHandler: 'search')
    view.addSubview(@table)
    initAMScrollingNavbar
  end

  def registerEvents
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
    expectedLabelSize1 = AppHelper.decodeHTMLEntities(question.title).sizeWithFont(QuestionCell::TITLE_FONT, constrainedToSize: maximumLabelSize)
    expectedLabelSize2 = AppHelper.decodeHTMLEntities(question.tags.join(', ')).sizeWithFont(QuestionCell::SUB_TITLE_FONT, constrainedToSize: maximumLabelSize)
    [QuestionCell::CELL_SPACING, expectedLabelSize1.height, QuestionCell::CELL_SPACING, expectedLabelSize2.height, QuestionCell::CELL_SPACING/2].reduce(:+)
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(QuestionCell.reuseIdentifier) || begin
      QuestionCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: QuestionCell.reuseIdentifier)
    end

    cell.question = questionAtIndexPath(indexPath)
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    questionController = QuestionController.alloc.initWithQuestion(questionAtIndexPath(indexPath))
    navigationController.pushViewController(questionController, animated: true)
  end

  def questionAtIndexPath(indexPath)
    @questions[indexPath.row]
  end

  def displayQuestions(notification)
    @questions += notification.object
    @table.reloadData
    hideProgress
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
    navigationItem.title = 'Popular Questions'
    Question.top
    showProgress
  end

  def registerEvents
    'TopQuestionsFetched'.add_observer(self, 'displayQuestions:')
  end

end

class QuestionsSearchController < QuestionsController

  private

  def performHousekeepingTasks
    navigationItem.title = 'Search'
    createSearchBar
    size = view.bounds.size
    @table = createTable(frame: [[0, 44], [size.width, size.height - 44]])
    view.addSubview(@table)
  end

  def registerEvents
    'QuestionsFetched'.add_observer(self, 'displayQuestions:')
  end

  def createSearchBar
    size = view.bounds.size
    @searchBar = UISearchBar.alloc.initWithFrame([[0, 0], [size.width, 44]])
    @searchBar.tintColor = '#fff'.uicolor
    @searchBar.backgroundColor = '#fff'.uicolor
    @searchBar.delegate = self
    @searchBar.placeholder = 'Search'
    view.addSubview(@searchBar)
  end

  def searchBarSearchButtonClicked(searchBar)
    view.endEditing(true)
    term = searchBar.text
    return unless term
    Question.search(tagged: term)
    showProgress
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
    @tag.fetch_questions
    showProgress
  end

  def registerEvents
    'QuestionsByTagFetched'.add_observer(self, 'displayQuestions:')
  end

end