//
//  UIViewController.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 24/06/2021.
//

import Foundation
import UIKit

extension UIViewController: Storyboarded {
    
    static var identifier: String {
        let className = "\(self)"
        let components = className.split{$0 == "."}.map ( String.init )
        return components.last!
    }
        
    public var embededInEmptyNavController: UINavigationController {
        UINavigationController(rootViewController: self)
    }
    
    func showAlert(title: String?, message: String, completion: (()->())? = nil) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "Confirm",
                style: .default,
                handler: { _ in
                    completion?()
                }
            )
        )
        
        self.present(alertController, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(
            frame: CGRect(
                x: self.view.frame.size.width / 2 - 100,
                y: self.view.frame.size.height - 135,
                width: 200,
                height: 35
            )
        )
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.numberOfLines = 0
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: { isCompleted in
            UIView.animate(withDuration: 1, delay: 3, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { isCompleted in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
