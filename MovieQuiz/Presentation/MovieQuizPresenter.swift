//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 23.04.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?

    private var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticService: StatisticService!

    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
                
        statisticService = StatisticServiceImplementation()
                
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    
    // MARK: - Actions

    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)

    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.renderView(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion(index: currentQuestionIndex)
        viewController?.hideLoadingIndicator()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    private func showNextQuestionOrResults() {
        viewController?.buttonsState(enabled: true)
        
        if self.isLastQuestion() {
            
            let quizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: makeResultsMessage(), buttonText: "Сыграть еще раз")
            viewController?.show(quiz: quizResultsViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion(index: currentQuestionIndex)
            viewController?.renderQuestion()
        }
    }

    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion(index: currentQuestionIndex)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        markCorrect(isCorrect: isCorrect)
        viewController?.buttonsState(enabled: false)
        viewController?.imageWithBorder(result: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func markCorrect(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    func makeResultsMessage() -> String {
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                
                let bestGame = statisticService.bestGame
                
                let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
                let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
                let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)"
                + " (\(bestGame.date.dateTimeString))"
                let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
                
                let resultMessage = [
                    currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
                ].joined(separator: "\n")
                
                return resultMessage
            }

}
