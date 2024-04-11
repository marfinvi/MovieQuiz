//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 09.04.2024.
//

import Foundation

//show quiz result
struct AlertModel {
    //alert text title
    let title: String
    //alert message text
    let message: String
    //alert text button
    let buttonText: String
    let completion: () -> Void
}
