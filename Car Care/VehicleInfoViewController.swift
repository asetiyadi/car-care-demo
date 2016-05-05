//
//  AddVehicleViewController.swift
//  Car Care
//
//  Created by Andi Setiyadi on 3/30/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

class VehicleInfoViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: Outlet
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameTextfield: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    var selectedCarSpecType: String?
    var car: Car?
    lazy var isCarImageSet: Bool = false
    lazy var isExistingCar: Bool = false
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mileageTextField.delegate = self
        imagePicker.delegate = self
        
        Utility.requiredTextField(carNameTextfield, color: Constant.ColorTheme.MY_VEHICLES)
        
        // Assign tap gesture to carImageView
        let tap = UITapGestureRecognizer(target: self, action: #selector(VehicleInfoViewController.getCarImage))
        carImageView.addGestureRecognizer(tap)
        
        if(car == nil) {
            car = NSEntityDescription.insertNewObjectForEntityForName("Car", inManagedObjectContext: managedObjectContext) as? Car
        }
        else {
            deleteButton.hidden = false
            
            if let carName = car?.name where car?.name != Constant.SETUP_FIRST_CAR {
                carNameTextfield.text = carName
            }
            else {
                carNameTextfield.text = ""
            }
            
            let mileage = car!.registerMileage == 0 || car!.registerMileage == nil ? "" : String(car!.registerMileage!)
            mileageTextField.text = mileage
            
            let make = car?.make == nil || car!.make == "" ? "Make" : car!.make!
            makeButton.setTitle(make, forState: UIControlState.Normal)
            
            let model = car?.model == nil || car!.model == "" ? "Model" : car!.model!
            modelButton.setTitle(model, forState: UIControlState.Normal)
            modelButton = make == "" || make == "Make" ? Utility.disableButton(modelButton) : Utility.enableButton(modelButton)
            
            let year = car?.year == nil || car!.year == 0 ? "Year" : String(car!.year!)
            yearButton.setTitle(year, forState: UIControlState.Normal)
            yearButton = model == "" || model == "Model" ? Utility.disableButton(yearButton) : Utility.enableButton(yearButton)
            
            if let imageData = car!.image {
                carImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Action
    
    // This will be invoked when users tap Make | Model | Year | Submodel when adding vehicle
    // The task is to get the data from CoreData to display available option for each category
    @IBAction func carSpecAction(sender: UIButton) {
        switch sender.tag {
        case 0:
            selectedCarSpecType = "make"
            
        case 1:
            selectedCarSpecType = "model"
            
        case 2:
            selectedCarSpecType = "year"
            
        default:
            print("invalid sender")
        }
        
        performSegueWithIdentifier("segueCarSpec", sender: self)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        saveVehicle()
    }
    
    @IBAction func exitAction(sender: UIButton) {
        let alertController = UIAlertController(title: "ADD VEHICLE", message: "Do you need to SAVE the current vehicle entry?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "SAVE", style: UIAlertActionStyle.Default) { (action) in
            self.saveVehicle()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) in
            if !self.isExistingCar {
                self.managedObjectContext.deleteObject(self.car!)
                do {
                    try self.managedObjectContext.save()
                }
                catch {
                    fatalError("Error deleting car")
                }
            }
            else {
                self.managedObjectContext.reset()
            }

            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveVehicle()  {
        if carNameTextfield.text == "" {
            let alertController = UIAlertController(title: "VEHICLE INFO", message: "Please provide the \"Car Name\" for this vehicle", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in }
            
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            guard let carName = carNameTextfield.text else { return }
            self.car?.name = carName
            
            guard let mileage = mileageTextField.text else { return }
            self.car?.registerMileage = Int(mileage)
            
            if !isCarImageSet && !isExistingCar {
                let carData = UIImageJPEGRepresentation(UIImage(named: "camera")!, 1.0)
                car?.image = carData
            }

            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error saving new vehicle")
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func deleteAction(sender: UIButton) {
       
        let alertController = UIAlertController(title: "DELETE VEHICLE", message: "Please confirm you would like to delete this vehicle", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yesAction = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Destructive) { (action) in
            self.managedObjectContext.deleteObject(self.car!)
            do {
                try self.managedObjectContext.save()
            }
            catch {
                fatalError("Error deleting car")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) in
            
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func getCarImage() {
        let photoAlert = UIAlertController(title: "ADD IMAGE", message: "Please select your image source", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.imagePicker.allowsEditing = false
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imagePicker.allowsEditing = false
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        photoAlert.addAction(cameraAction)
        photoAlert.addAction(photoLibraryAction)
        
        presentViewController(photoAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        carImageView.image = image
        
        let carImageData = UIImageJPEGRepresentation(image, 1)
        car?.image = carImageData
        
        isCarImageSet = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCarSpec" {
            let carOptionController = segue.destinationViewController as! CarOptionTableViewController
            carOptionController.selectedCarSpecType = selectedCarSpecType
            carOptionController.managedObjectContext = managedObjectContext
            carOptionController.car = car
            carOptionController.delegate = self
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        Utility.addDoneButtonOnKeyboard(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension VehicleInfoViewController: CarSpecsDelegate {

    func updateCar(car: Car) {
        self.car = car
        
        if let year = self.car!.year where self.car!.year != 0 {
            yearButton.setTitle(String(year), forState: UIControlState.Normal)
        }
        else if let model = self.car!.model where self.car!.model != "" {
            // Update button title to match the car model selected
            modelButton.setTitle(model, forState: UIControlState.Normal)
            
            yearButton.enabled = true
            yearButton.setTitle("Year", forState: UIControlState.Normal)
            yearButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
        else if let make = self.car!.make where self.car!.make != "" {
            makeButton.setTitle(make, forState: UIControlState.Normal)
            
            // Enable the model button if car make has been selected
            modelButton.enabled = true
            modelButton.setTitle("Model", forState: UIControlState.Normal)
            modelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            
            yearButton.enabled = false
            yearButton.setTitle("Year", forState: UIControlState.Normal)
            yearButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        }
    }
}