//
//  UIView+Retrica.swift
//  Retrica
//
//  Created by pisces on 9/7/16.
//  Copyright © 2016 Sangwon Park. All rights reserved.
//

import UIKit

public extension UIView {
    var right: CGFloat {
        return x + width
    }
    
    var bottom: CGFloat {
        return y + height
    }
    
    var x: CGFloat {
        return CGRectGetMinX(self.frame)
    }
    
    var y: CGFloat {
        return CGRectGetMinY(self.frame)
    }
    
    var height: CGFloat {
        return CGRectGetHeight(self.frame)
    }
    
    var width: CGFloat {
        return CGRectGetWidth(self.frame)
    }
    
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            name = nibName
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    public class var nib: UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    public func fitSubview(subview: UIView) {
        let leading = NSLayoutConstraint(item: subview, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: subview, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let top = NSLayoutConstraint(item: subview, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: subview, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
        self.addConstraints([leading, trailing, top, bottom])
    }
    
    public func showGuidelines() {
        let value = CGFloat(Int(NSDate().timeIntervalSince1970) + self.hash)
        let r = (value % 255) / 255.0
        let g = ((value / 255) % 255) / 255.0
        let b = CGFloat(self.hash % 255) / 255.0
        
        self.layer.borderColor = UIColor(red: r, green: g, blue: b, alpha: 1).CGColor
        self.layer.borderWidth = 1.0;
        
        for subview in self.subviews {
            subview.showGuidelines()
        }
    }
}
