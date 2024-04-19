//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 02.04.2024.
//

import Foundation

struct QuizQuestion {
    // строка с названием фильма
    // совпадает с вопросом о рейтинге фильма в Assets
    let image: Data
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
