//
//  ServiceInfoViewController.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/2/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

class ServiceInfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var serviceTypeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var serviceByTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // MARK: Properties - passed in by ServiceRecordViewController
    
    var car: Car!
    var selectedRecord: Service!
    var isExistingRecord = false
    
    
    var activeTextField: UITextField!
    var activeTextView: UITextView!
    var maintenanceService: MaintenanceService!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextField.layer.borderWidth = 0.5
        noteTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        noteTextField.layer.cornerRadius = 4
        
        // Required fields
        Utility.requiredTextField(serviceTypeTextField, color: Constant.ColorTheme.SERVICE_HISTORY)
        Utility.requiredTextField(dateTextField, color: Constant.ColorTheme.SERVICE_HISTORY)
        Utility.requiredTextField(mileageTextField, color: Constant.ColorTheme.SERVICE_HISTORY)
        
        // Save Button
        Utility.setFrameButton(saveButton, color: Constant.ColorTheme.SERVICE_HISTORY)
        
        carNameLabel.text = car.name
        
        maintenanceService = MaintenanceService(managedObjectContext: managedObjectContext)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        registerForKeyboardNotifications()
        
        if isExistingRecord {
            deleteButton.hidden = false
            
            serviceTypeTextField.text = selectedRecord.type
            dateTextField.text = Utility.dateToString(selectedRecord.date!)
            serviceByTextField.text = selectedRecord.location
            costTextField.text = String(selectedRecord.cost!)
            mileageTextField.text = String(selectedRecord.mileage!)
            noteTextField.text = selectedRecord.note
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        guard let serviceType = serviceTypeTextField.text where serviceTypeTextField.text != "" else {
            alertRequiredForm()
            return
        }
        
        var serviceDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        guard let dateValue = dateTextField.text where dateTextField.text != ""  else {
            alertRequiredForm()
            return
        }
        serviceDate = dateFormatter.dateFromString(dateValue)!
        
        guard let mileageValue = mileageTextField.text where mileageTextField.text != "" else {
            alertRequiredForm()
            return
        }
        let mileage = Int(mileageValue)!
        

        let serviceBy = serviceByTextField.text
        
        var cost = 0.00
        if let costValue = costTextField.text {
            cost = NSString(string: costValue).doubleValue
        }
        
        
        //if let noteValue = noteTextField.text else { return }
        let note = noteTextField.text
        
        if isExistingRecord {
            maintenanceService.updateServiceRecord(car, currentRecord: selectedRecord, type: serviceType, date: serviceDate, serviceBy: serviceBy!, cost: cost, mileage: mileage, note: note)
        }
        else {
            maintenanceService.insertServiceRecord(car, type: serviceType, date: serviceDate, serviceBy: serviceBy!, cost: cost, mileage: mileage, note: note)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func deleteAction(sender: UIButton) {
        let alertController = UIAlertController(title: "DELETE SERVICE RECORD", message: "Please confirm you would like to delete this service record", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yesAction = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Destructive) { (action) in
            self.maintenanceService.deleteServiceRecord(self.selectedRecord!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) in
            
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Datepicker
    
    @IBAction func dateFieldAction(sender: UITextField) {
        sender.text = Utility.dateToString(NSDate())
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 0, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        inputView.addSubview(datePickerView)
        
        // DONE action
        /*let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        doneButton.addTarget(self, action: #selector(ServiceInfoViewController.doneButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        inputView.addSubview(doneButton)*/
        
        sender.inputView = inputView
        //sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ServiceInfoViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func doneButton(sender:UIButton)
    {
        dateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func alertRequiredForm() {
        let alertController = UIAlertController(title: "ADD SERVICE RECORDS", message: "Please provide the \"Service Type, Date and Mileage\" for this service record", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Keyboard
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ServiceInfoViewController.keyboardWillBeShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ServiceInfoViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        
        if activeTextField != nil{
            let activeTextFieldRect: CGRect? = activeTextField?.frame
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
            if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
                scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
        else if activeTextView != nil {
            let activeTextViewRect: CGRect? = activeTextView?.frame
            let activeTextViewOrigin: CGPoint? = activeTextViewRect?.origin
            if (!CGRectContainsPoint(aRect, activeTextViewOrigin!)) {
                scrollView.scrollRectToVisible(activeTextViewRect!, animated:true)
            }
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    // MARK: Textfield
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        Utility.addDoneButtonOnKeyboard(activeTextField)
        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        activeTextField = nil
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeTextField = nil
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
        
        return true
    }
    
    
    // MARK: Textview
    
    func textViewDidBeginEditing(textView: UITextView) {
        scrollView.setContentOffset(CGPointMake(0, 120), animated: true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
            activeTextView = nil
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
            scrollView.scrollEnabled = false
            
            return false
        }
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
