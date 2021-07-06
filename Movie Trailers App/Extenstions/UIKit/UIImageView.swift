//
//  UIImageView.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 23/06/2021.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImage(withUrl url: String?, showLoader: Bool = false, completion: (()->())? = nil) {
        
        guard let url = URL(string: url ?? "") else { return }
        
        if showLoader {
            self.showLoader()
        }
        
        sd_setImage(with: url) { [weak self] _,_,_,_ in
            if showLoader {
                self?.hideLoader()
            }
        }
    }
}

// MARK: - LoadableObserver

extension UIImageView: LoadableObserver {
    
    func update<T>(with newValue: T) {
        if let newImage = newValue as? UIImage {
            image = newImage
        }
    }
    
    func showLoader() {
        let loader = UIActivityIndicatorView(frame: self.bounds)
        addSubview(loader)
        loader.center(inView: self)
        loader.startAnimating()
    }
    
    func hideLoader() {
        subviews.filter { view in view is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
}
