//
//  UITextField.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 25/06/2021.
//

import UIKit

extension UITextField {
    
    @IBInspectable var showDoneButton: Bool {
        get {
            return self.showDoneButton
        }
        set {
            if newValue {
                addDoneCancelToolbar()
            }
        }
    }
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.backgroundColor = .lightGray
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(
                title: "Done",
                style: .done,
                target: onDone.target,
                action: onDone.action
            ),
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: self,
                action: nil
            )
        ]
        
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
}
