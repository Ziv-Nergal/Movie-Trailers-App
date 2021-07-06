//
//  UIView + Shimmer.swift
//  Interacting Technology Test
//
//  Created by זיו נרגל on 26/06/2021.
//

import UIKit

extension UIView {
    
    public func shimmer() {
        layoutIfNeeded()
        animateShimmer(view: self, start: true)
    }
    
    public func stopShimmer() {
        animateShimmer(view: self, start: false)
    }
    
    public func smartShimmer() {
        addLoader(self, start: true)
    }
    
    public func stopSmartShimmer() {
        addLoader(self, start: false)
    }
    
    public func toggleLabelsShimmer(on: Bool, hideOthers: Bool = false) {
        
        loopViewHierarchy { (view) -> Bool in
            
            if view is UILabel {
                
                if on {
                    view.shimmer()
                } else {
                    view.stopShimmer()
                }
                
                return false // do not iterate view's subviews
            } else if hideOthers && view.subviews.count == 0 {
                view.isHidden = on
            }
            
            return true // keep iterating subviews
        }
    }
    
    private func addLoader(_ view: UIView, start: Bool) {
        DispatchQueue.main.async {
            view.layoutIfNeeded()
            for subView in view.subviews {
                self.animateShimmer(view: subView, start: start)
            }
        }
    }
    
    private func animateShimmer(view:UIView, start: Bool) {
        
        if start {
            
            isUserInteractionEnabled = false
            
            let firstColor: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.42 : 0.92
            let secondColor: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.46 : 0.96
            
            // 1. Add Color Layer
            let colorLayer = CALayer()
            colorLayer.backgroundColor = UIColor(white: firstColor, alpha: 1).cgColor
            colorLayer.frame = view.bounds
            colorLayer.name = "colorLayer"
            view.layer.addSublayer(colorLayer)
            view.autoresizesSubviews = true
            if view.cornerRadius == 0, !(view is UIImageView) {
                view.cornerRadius = 5
            }
            
            // 2. Add loader Layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(white: firstColor, alpha: 1).cgColor,
                UIColor(white: secondColor, alpha: 1).cgColor,
                UIColor(white: firstColor, alpha: 1).cgColor
            ]
            gradientLayer.locations = [0,0.4,0.8, 1]
            gradientLayer.name = "loaderLayer"
                        
            gradientLayer.startPoint = CGPoint(x: 0.0, y: view is UIImageView ? 0.4 : 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: view is UIImageView ? 0.6 : 0.5)
            gradientLayer.frame = view.bounds
            view.layer.addSublayer(gradientLayer)
            
            // 3. Animate loader layer
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.2
            if UIApplication.isRtl {
                animation.fromValue = view.frame.width
                animation.toValue = -view.frame.width
            } else {
                animation.fromValue = -view.frame.width
                animation.toValue = view.frame.width
            }
            animation.repeatCount = Float.infinity
            gradientLayer.add(animation, forKey: "smartLoader")
        } else {
            
            isUserInteractionEnabled = true
            
            if let smartLayers = view.layer.sublayers?.filter({$0.name == "colorLayer" || $0.name == "loaderLayer"}) {
                smartLayers.forEach({$0.removeFromSuperlayer()})
            }
        }
    }
}
