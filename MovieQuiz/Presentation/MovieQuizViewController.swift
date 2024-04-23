import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenter?
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

