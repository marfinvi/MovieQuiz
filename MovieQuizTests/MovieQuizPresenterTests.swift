//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Владислав Марфин on 24.04.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func renderView(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func buttonsState(enabled: Bool) {
        
    }
    
    func renderQuestion() {
        
    }
    
    func imageWithBorder(result: Bool) {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
    
    }
    
    func show(quiz result: QuizResultsViewModel) {
    
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
    
    func showNetworkError(message: String) {
    
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
         XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
