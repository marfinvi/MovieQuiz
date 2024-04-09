//
//  AlertFactory.swift
//  MovieQuiz
//
//  Created by Владислав Марфин on 09.04.2024.
//

import Foundation
import UIKit

final class AlertFactory: AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
                alertModel.completion()
            }
            alert.addAction(action)
        
            viewController?.present(alert, animated: true)
    }
}
