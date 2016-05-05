//
//  MyVehicleViewController.swift
//  Car Care
//
//  Created by Andi Setiyadi on 3/30/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

class MyVehicleViewController: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var carCollectionView: UICollectionView!
    @IBOutlet weak var innerView: UIView!
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    var cars = [Car]()
    var selectedCar: Car?
    var sceneType: String?
    var viewModel: MyVehicleViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carCollectionView.delegate = self
        viewModel = MyVehicleViewModel(managedObjectContext: managedObjectContext)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        cars = viewModel.getCarDatasource()
        
        // If users do not have any vehicle setup and try to access Service History or Mileage Tracker module,
        // shows the alert asking them to setup the vehicle prior to use these modules
        if sceneType == Constant.SceneType.SERVICE_RECORDS || sceneType == Constant.SceneType.MILEAGE_TRACKER {
            if cars.count == 1 && cars[0].name == Constant.SETUP_FIRST_CAR {
                selectedCar = cars[0]
                alertFirstCarSetup()
            }
        }
        
        carCollectionView.reloadData()
    }
    
    func alertFirstCarSetup() {
        let alertController = UIAlertController(title: "SETUP YOUR FIRST VEHICLE", message: "You will need to setup your first vehicle before you can enter Service History or Mileage Tracker records.\n Please go to Main Menu and select \"MY VEHICLES\" to setup your car", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            self.viewModel.deleteCar(self.selectedCar!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("MEMORY WARNING ALERT")
    }
    
    @IBAction func homeAction(sender: UIButton) {
        if selectedCar?.name == Constant.SETUP_FIRST_CAR {
            viewModel.deleteCar(selectedCar!)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UICollectionView layout
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(carCollectionView.frame.size.width, carCollectionView.frame.size.height/3)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constant.SegueIdentifier.ADD_VEHICLE {
            let vehicleInfoController = segue.destinationViewController as! VehicleInfoViewController
            vehicleInfoController.managedObjectContext = managedObjectContext
            
            if selectedCar != nil && selectedCar?.name == Constant.SETUP_FIRST_CAR {
                viewModel.deleteCar(selectedCar!)
            }
        }
        else if segue.identifier == Constant.SegueIdentifier.EDIT_VEHICLE {
            let vehicleInfoController = segue.destinationViewController as! VehicleInfoViewController
            vehicleInfoController.managedObjectContext = managedObjectContext
            
            vehicleInfoController.car = selectedCar
            vehicleInfoController.isExistingCar = true
        }
        /*else if segue.identifier == Constant.SegueIdentifier.SERVICE_RECORDS {
            let serviceController = segue.destinationViewController as! ServiceRecordViewController
            serviceController.managedObjectContext = managedObjectContext
            serviceController.car = selectedCar
        }
        else if segue.identifier == Constant.SegueIdentifier.MILEAGE_TRACKER_ENTRY {
            let mileageController = segue.destinationViewController as! MileageTrackerViewController
            mileageController.managedObjectContext = managedObjectContext
            mileageController.car = selectedCar
        }*/
    }
}

extension MyVehicleViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = carCollectionView.dequeueReusableCellWithReuseIdentifier("cellCar", forIndexPath: indexPath) as! MyVehicleCollectionViewCell
        
        cell.frame.size.width = innerView.frame.size.width
        cell.frame.size.height = innerView.frame.size.height/3
        
        let car = cars[indexPath.row]
        
        if car.image != nil {
            cell.carImageView.image = UIImage(data: car.image!)
        }
        
        cell.carLabel.text = car.name
        
        return cell
    }
}

extension MyVehicleViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCar = cars[indexPath.row]
        
        if sceneType == Constant.SceneType.MY_VEHICLES {
            performSegueWithIdentifier(Constant.SegueIdentifier.EDIT_VEHICLE, sender: self)
        }
        else if sceneType == Constant.SceneType.SERVICE_RECORDS {
            performSegueWithIdentifier(Constant.SegueIdentifier.SERVICE_RECORDS, sender: self)
        }
        else if sceneType == Constant.SceneType.MILEAGE_TRACKER {
            performSegueWithIdentifier(Constant.SegueIdentifier.MILEAGE_TRACKER_ENTRY, sender: self)
        }
        
    }
}
