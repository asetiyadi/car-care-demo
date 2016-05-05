//
//  ViewController.swift
//  Car Care
//
//  Created by Andi Setiyadi on 3/24/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var addVehicleButton: UIButton!
    @IBOutlet weak var serviceHistoryButton: UIButton!
    @IBOutlet weak var mileageTrackerButton: UIButton!
    @IBOutlet weak var roadAssistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constant.SegueIdentifier.ROAD_ASSIST {
            /*let roadAssistController = segue.destinationViewController as! RoadAssistViewController
            roadAssistController.managedObjectContext = managedObjectContext*/
        }
        else if segue.identifier == Constant.SegueIdentifier.AUTO_SHOP {
            /*let autoShopController = segue.destinationViewController as! AutoShopViewController
            autoShopController.managedObjectContext = managedObjectContext*/
        }
        else {
            let myVehicleController = segue.destinationViewController as! MyVehicleViewController
            myVehicleController.managedObjectContext = managedObjectContext
            
            switch segue.identifier! {
            case Constant.SegueIdentifier.MY_VEHICLES:
                myVehicleController.sceneType = Constant.SceneType.MY_VEHICLES
                
            case Constant.SegueIdentifier.SERVICE_HISTORY:
                myVehicleController.sceneType = Constant.SceneType.SERVICE_RECORDS
                
            case Constant.SegueIdentifier.MILEAGE_TRACKER:
                myVehicleController.sceneType = Constant.SceneType.MILEAGE_TRACKER
                
            default:
                print("invalid segue from HOME")
            }
        }
        
    }
}

