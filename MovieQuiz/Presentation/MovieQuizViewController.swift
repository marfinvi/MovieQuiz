import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // Описание модели отображения элементов 
    /*
    private struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    */
    //private var currentQuestionIndex = 0
    //private var correctAnswers = 0
    //private let questionsAmount: Int = 10
    
    //private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    //private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter?


    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter!.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter!.noButtonClicked()
    }
    


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20.0

        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertFactory(viewController: self)
        presenter!.viewController = self
    }
    
    func renderView(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    func renderQuestion(){
        imageView.layer.borderWidth = 0
    }
    
    func imageWithBorder(result: Bool) {
        let color: UIColor = result ? .ypGreen : .ypRed
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 8
    }

    /*
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    */
    // MARK: - Private functions
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: {
                self.presenter!.restartGame()
        
                self.renderQuestion()
            })
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    /*
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
 */
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: {
                self.presenter!.restartGame()
        
                self.renderQuestion()
            })
        
        alertPresenter?.show(alertModel: alertModel)
    }
   
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    /*
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // 1
        imageView.layer.borderWidth = 8 // 2
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3
        if isCorrect {
            correctAnswers += 1
        }
      
        changeStateButtons(isEnabled: false)
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    */


    
    // функция которая делает рамку прозрачной
    private func borderColorClear() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func changeStateButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }


    func buttonsState(enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
}

