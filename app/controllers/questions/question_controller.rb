class QuestionController < UIViewController

  include UIViewControllerExtension
  include AppHelper

  attr_accessor :question

  def initWithQuestion(question)
    @question = question
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  private

  def performHousekeepingTasks
    navigationItem.title = decodeHTMLEntities(@question.title)
  end

end