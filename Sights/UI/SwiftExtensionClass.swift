//
//  SwiftExtensionClass.swift
//  ItemBI
//
//  Created by HARSHIT on 07/04/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

extension String
{
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension Date
{
    // Convert local time to UTC (or GMT)
    public func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    public func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var timestampString: String?
    {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone.current
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.calendar = calendar
                
        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }
        
        let formatString = NSLocalizedString("%@", comment: "")
        return String(format: formatString, timeString)
    }
}

extension UITextField
{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UIView
{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIViewController
{
    var App_Delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
        
    func ToastNotification(title:String, message:String, type:Int)
    {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction.init(title: "Ok", style: .default)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil);
    }
}


@IBDesignable open class DashedBorderedView: UIView
{
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    
    override open func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.lineWidth = borderWidth
        borderColor.setStroke()
        let dashPattern : [CGFloat] = [10, 4]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}


import ESTabBarController_swift

class ExampleBasicContentView: ESTabBarItemContentView {

    public var duration = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconColor = UIColor.gray
        highlightIconColor = UIColor.black
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}


class Screen: NSObject {
    
    class func SCREEN_SIZE () -> CGSize{
        return UIScreen.main.bounds.size
    }
    
    class func SCREEN_WIDTH () -> CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    class func SCREEN_HEIGHT () -> CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    class func SCREEN_MAX_LENGTH () -> CGFloat{
        return max(Screen.SCREEN_WIDTH(), Screen.SCREEN_HEIGHT())
    }
    
    class func SCREEN_MIN_LENGTH () -> CGFloat{
        return  min(Screen.SCREEN_WIDTH(), Screen.SCREEN_HEIGHT())
    }
    
    class func WIDTHFORPER (per: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.size.width * per / 100.0
    }
    
    class func HEIGHTFORPER (per: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.size.height * per / 100.0
    }
    
    class func SCREEN_CENTER () -> CGPoint{
        return CGPoint(x: Screen.SCREEN_WIDTH()/2 , y: Screen.SCREEN_HEIGHT()/2 )
    }
    
    class func SCREEN_CENTER_PER ( w: CGFloat , h: CGFloat) -> CGPoint{
        return CGPoint(x: Screen.WIDTHFORPER(per: w) , y: Screen.HEIGHTFORPER(per: h))
    }
}
