//
//  UIView.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 21/06/2021.
//

import UIKit

extension UIView {
    
    static var instance: Self {
        return Bundle.main.loadNibNamed(
            identifier,
            owner: self,
            options: nil
        )?.first as! Self
    }
    
    static var identifier: String {
        let className = "\(self)"
        let components = className.split{$0 == "."}.map ( String.init )
        return components.last!
    }
    
    var id: String {
        if self.accessibilityIdentifier == nil {
            self.accessibilityIdentifier = UUID().uuidString
        }
        
        return self.accessibilityIdentifier!
    }
    
    // MARK: - Animations
     
    public func addTransition(
        withType type: CATransitionType,
        subType: CATransitionSubtype? = .none,
        _ duration:CFTimeInterval = 0.25
    ) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = type
        animation.subtype = subType
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    // MARK: - Loop
    
    func loopViewHierarchy(block: ((_ view: UIView) -> Bool)?) {
        
        if block?(self) ?? true {
            for subview in subviews {
                subview.loopViewHierarchy(block: block)
            }
        }
    }
    
    // MARK: - Radius
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
    }
    
    @IBInspectable var isElliptic: Bool {
        get {
            cornerRadius == viewHeight / 2 || cornerRadius == viewWidth / 2
        }
        set {
            if newValue {
                cornerRadius = viewWidth > viewHeight ? viewHeight / 2 : viewWidth / 2
                clipsToBounds = true
            } else {
                cornerRadius = 0
                clipsToBounds = false
            }
        }
    }
    
    func makeCircle() {
        layer.cornerRadius = viewHeight / 2
        clipsToBounds = true
    }
    
    // MARK: - Shadow
    
    @IBInspectable var shadowColor: CGColor {
        get {
            layer.shadowColor ?? UIColor.darkGray.cgColor
        }
        set {
            layer.shadowColor = newValue
        }
    }
    
    @IBInspectable var shadowOffsetWidth: CGFloat {
        get {
            layer.shadowOffset.width
        }
        set {
            layer.shadowOffset.width = newValue
        }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat {
        get {
            layer.shadowOffset.height
        }
        set {
            layer.shadowOffset.height = newValue
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float {
        get {
            layer.shadowOpacity == 0 ? 0.1 : layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowRadius != 0
        }
        set {
            if newValue {
                dropShadow()
            }
        }
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(
            width: shadowOffsetWidth,
            height: shadowOffsetHeight == -3
                ? 0 : shadowOffsetHeight
        )
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: - Border
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    func removeGradient() {
        if let subLayers = layer.sublayers {
            for layer in subLayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = .init(x: 0.6, y: 1)
        gradient.endPoint = .init(x: 1, y: 0.6)
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    // MARK: - Constraints
    
    func center(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    enum Sides {
        case Top
        case Bottom
        case Leading
        case Trailing
    }
    
    func pinEdges(to view: UIView,
                  sides: [Sides] = [],
                  topMargin: CGFloat = 0,
                  bottomMargin: CGFloat = 0,
                  leadingMargin: CGFloat = 0,
                  trailingMargin: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if sides.isEmpty || sides.contains(.Top) {
            topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: topMargin
            ).isActive = true
        }
        
        if sides.isEmpty || sides.contains(.Bottom) {
            bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: bottomMargin
            ).isActive = true
        }
        
        if sides.isEmpty || sides.contains(.Leading) {
            leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: leadingMargin
            ).isActive = true
        }
        
        if sides.isEmpty || sides.contains(.Trailing) {
            trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: trailingMargin
            ).isActive = true
        }
    }
    
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    var ending: CGPoint { return CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height) }
    
    var viewWidth: CGFloat { return frame.width }
    
    var viewHeight: CGFloat { return frame.height }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: nil,
                               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
    
    // MARK: - Animations
    
    func highlightTapAnimation(isHighlighted: Bool, completion: (()->())? = nil) {
        UIView.animate(
            withDuration: 0.6,
            delay: 0.05,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut, .allowUserInteraction]) { [weak self] in
            self?.transform = isHighlighted ?
                .init(scaleX: 0.98, y: 0.98) :
                .init(scaleX: 1, y: 1)
        } completion: { (isFinished) in
            completion?()
        }
    }
    
    func shake(withDuration duration: Double = 0.25) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.055
        animation.repeatCount = floor(Float((duration / 2) / animation.duration.binade))
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        layer.add(animation, forKey: "position")
    }
    
    // MARK: - Localization
    
    @IBInspectable var languageBasedRotation: Bool {
        get {
            let radians: Double = atan2(Double(transform.b), Double(scaleX))
            let degrees: CGFloat = CGFloat(radians) * (CGFloat(180) / CGFloat(Double.pi))
            return degrees == 0
        }
        set {
            if !UIApplication.isRtl {
                transform = CGAffineTransform(rotationAngle: .pi)
            }
        }
    }
    
    // MARK: - Scale
    
    public var scaleX: CGFloat {
        get {
            transform.a
        }
        set {
            transform.a = newValue
        }
    }
    
    public var scaleY: CGFloat {
        get {
            transform.d
        }
        set {
            transform.d = newValue
        }
    }
    
    public func animateAlpha(toVisible isVisible: Bool, withDuration duration: Double = 0.35, completion: (()->())? = nil) {
        
        if (alpha == 1 && isVisible) || (alpha == 0 && !isVisible) {
            return
        }
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = isVisible ? 1 : 0
        } completion: { _ in
            completion?()
        }
    }
    
    public func animateScale(toVisible isVisible: Bool, withDuration duration: Double = 0.35) {
        
        if (scaleX == 1 && isVisible) || (scaleX == 0 && !isVisible) {
            return
        }
        
        let scale: CGFloat = isVisible ? 1 : 0.01
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = .init(scaleX: scale, y: scale)
        }
    }
    
    // MARK: - Blur
    
    func blurView(style: UIBlurEffect.Style) {
        var blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    func removeBlur() {
        for view in self.subviews {
            if let view = view as? UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
}
