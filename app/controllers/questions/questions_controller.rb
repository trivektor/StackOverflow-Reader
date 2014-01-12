class UITableViewCell
  def self.reuseIdentifier
    self.class.to_s
  end
end

class QuestionCell < UITableViewCell

  include AppHelper
  attr_accessor :question, :titleLabel, :subTitleLabel

  CELL_SPACING = 8

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
  end

  def render
    self.contentView.subviews.each { |v| v.removeFromSuperview }
    maximumLabelSize = CGSizeMake(298, CGFLOAT_MAX)

    titleLabelHeight = question.title.sizeWithFont('HelveticaNeue-Light'.uifont(14), constrainedToSize: maximumLabelSize).height
    @titleLabel = UILabel.alloc.initWithFrame([[11, CELL_SPACING], [298, titleLabelHeight]])
    @titleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @titleLabel.text = decodeHTMLEntities(@question.title)
    @titleLabel.numberOfLines = 0
    @titleLabel.font = 'HelveticaNeue-Light'.uifont(14)
    @titleLabel.sizeToFit

    self.contentView.addSubview(@titleLabel)

    subTitleLabelHeight = question.tags.join(', ').sizeWithFont('HelveticaNeue-Light'.uifont(13), constrainedToSize: maximumLabelSize).height
    @subTitleLabel = UILabel.alloc.initWithFrame([[11, @titleLabel.frame.size.height + CELL_SPACING*3/2], [298, subTitleLabelHeight + CELL_SPACING]])
    @subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @subTitleLabel.text = decodeHTMLEntities(@question.tags.join(', '))
    @subTitleLabel.numberOfLines = 0
    @subTitleLabel.font = 'HelveticaNeue-Light'.uifont(13)
    @subTitleLabel.textColor = '#999'.uicolor
    @subTitleLabel.sizeToFit

    self.contentView.addSubview(@subTitleLabel)
  end

end

class QuestionsController < UIViewController

  include UIViewControllerExtension
  include AppHelper

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
    @table = createTable(cell: QuestionCell)
    view.addSubview(@table)

    #if navigationController.viewControllers.count == 1
    menuButton = UIBarButtonItem.alloc.initWithImage('399-list1.png'.uiimage, landscapeImagePhone: nil, style: UIBarButtonItemStyleBordered, target: self, action: 'showMenu')
    navigationItem.leftBarButtonItem = menuButton
    #end
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
    maximumLabelSize = CGSizeMake(298, CGFLOAT_MAX)
    expectedLabelSize1 = decodeHTMLEntities(question.title).sizeWithFont('HelveticaNeue-Light'.uifont(14), constrainedToSize: maximumLabelSize)
    expectedLabelSize2 = decodeHTMLEntities(question.tags.join(', ')).sizeWithFont('HelveticaNeue-Light'.uifont(13), constrainedToSize: maximumLabelSize)
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

end

class TopQuestionsController < QuestionsController

  def viewDidLoad
    super
    navigationItem.title = 'Top Questions'
  end

  def showMenu
    self.sideMenuViewController.presentMenuViewController
  end


end