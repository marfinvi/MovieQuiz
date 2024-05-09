//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 02.04.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []

    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion(index: Int) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
           do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let ratingQuestion = round(Float.random(in: 7.3 ... 9.5) * 10) / 10
            let text: String
            let correctAnswer: Bool
            let quest = Int.random(in: 0...20)
            if quest % 2 == 0 {
                text = "Рейтинг этого фильма больше чем \(ratingQuestion)?"
                correctAnswer = rating > ratingQuestion
            } else {
                text = "Рейтинг этого фильма меньше чем \(ratingQuestion)?"
                correctAnswer = rating < ratingQuestion
            }
            
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate!.didReceiveNextQuestion(question: question)
            }
        }
    }
}
