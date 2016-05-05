//
//  Utility.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/3/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit

struct Utility {
    
    /// This will format the textfield using the color theme for each module
    internal static func requiredTextField(sender: UITextField, color: UIColor) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = color.CGColor
        sender.layer.cornerRadius = 4
    }
    
    internal static func addDoneButtonOnKeyboard(view: UIView?)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 30))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: view, action: #selector(UIResponder.resignFirstResponder))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        if let accessorizedView = view as? UITextView {
            accessorizedView.inputAccessoryView = doneToolbar
            accessorizedView.inputAccessoryView = doneToolbar
        } else if let accessorizedView = view as? UITextField {
            accessorizedView.inputAccessoryView = doneToolbar
            accessorizedView.inputAccessoryView = doneToolbar
        }
    }
    
    internal static func enableButton(button: UIButton) -> UIButton {
        button.enabled = true
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        
        return button
    }
    
    internal static func disableButton(button: UIButton) -> UIButton {
        button.enabled = false
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        return button
    }
    
    
    // MARK: Formatter
    
    internal static func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
    
    internal static func dateFromString(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.dateFromString(dateString)!
    }
    
    internal static func stripPhoneFormat(phoneString: String) -> String {
        return phoneString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
    }
    
    internal static func formatToPhoneNumber(phoneString: String) -> NSMutableString {
        let phoneNumber = stripPhoneFormat(phoneString)
        let mutableString = NSMutableString(string: phoneNumber)
        
        mutableString.insertString("(", atIndex: 0)
        mutableString.insertString(")", atIndex: 4)
        mutableString.insertString(" ", atIndex: 5)
        mutableString.insertString("-", atIndex: 9)
        
        return mutableString
    }
    
    
    // MARK: Validation
    
    internal static func phoneDigitValidation(phoneString: String) -> Bool {
        if phoneString.characters.count < 10 {
            return false
        }
        return true
    }
    
    
    // MARK: View Helper
    
    internal static func showActivityIndicator(view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray

        return activityIndicator
    }
    
    
}