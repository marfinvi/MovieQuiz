//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 23.04.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func renderView(quiz step: QuizStepViewModel)
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func buttonsState(enabled: Bool)
    func renderQuestion()
    func imageWithBorder(result: Bool)
    func show(quiz result: QuizResultsViewModel)
    
}
