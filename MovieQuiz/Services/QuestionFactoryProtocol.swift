//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 04.04.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion(index: Int)
    func loadData()
}
