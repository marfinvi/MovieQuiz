import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        } // 1
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }// 1
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    // Описание модели отображения элементов
    private struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?


// MARK: - Lifecycle
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
                    image: UIImage(named: model.image) ?? UIImage(),
                    question: model.text,
                    questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
 
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
  
        let alertModel = AlertModel(
             title: result.title,
             message: result.text,
             buttonText: result.buttonText,
             completion: {
                 self.currentQuestionIndex = 0
                 self.correctAnswers = 0
         
                 self.renderQuestion()
             })
         
         alertPresenter?.show(alertModel: alertModel)
    }
   
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // 1
        imageView.layer.borderWidth = 8 // 2
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3
        if isCorrect {
            correctAnswers += 1
        }
        
        changeStateButtons(isEnabled: false)
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
    }
    
    private func renderQuestion(){
        imageView.layer.borderWidth = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {

            statisticService?.store(correct: correctAnswers, total: questionsAmount)
                        
            let statistics = statisticService!
            let bestGame = statistics.bestGame
                        
            let result = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            let quizes = "Количество сыгранных квизов: \(String(statistics.gamesCount))"
            let record = "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)"
            let accuracy = "Средняя точность: \(String(format: "%.2f", statistics.totalAccuracy))%"
                        
            let alertMessage = [result,quizes,record,accuracy].joined(separator: "\n")
                        
            let quizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: alertMessage, buttonText: "Сыграть еще раз")
                        show(quiz: quizResultsViewModel)
            borderColorClear()
            changeStateButtons(isEnabled: true)
        } else {
            currentQuestionIndex += 1
            borderColorClear()
            changeStateButtons(isEnabled: true)
            renderQuestion()
        }
    }
    
    // функция которая делает рамку прозрачной
    private func borderColorClear() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func changeStateButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertFactory(viewController: self)
        statisticService = StatisticServiceImplementation()

        renderQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
}




/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
