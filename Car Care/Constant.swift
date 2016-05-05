//
//  Constant.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/2/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    
    static let SETUP_FIRST_CAR = "Add your first car"
    
    struct SceneType {
        static let MY_VEHICLES = "myVehicles"
        static let SERVICE_RECORDS = "serviceRecords"
        static let MILEAGE_TRACKER = "mileageTracker"
    }
    
    struct SegueIdentifier {
        static let MY_VEHICLES = "segueMyVehicles"
        static let ADD_VEHICLE = "segueAddVehicle"
        static let EDIT_VEHICLE = "segueEditVehicle"
        
        //Service Records
        static let SERVICE_HISTORY = "segueServiceHistory"
        static let SERVICE_RECORDS = "segueServiceRecordList"
        static let SERVICE_RECORD_INFO = "segueServiceRecordInfo"
        static let SERVICE_RECORD_INFO_EDIT = "segueEditServiceRecord"
        
        //Mileage Tracker
        static let MILEAGE_TRACKER = "segueMileageTracker"
        static let MILEAGE_TRACKER_ENTRY = "segueMileageEntry"
        
        //Road Assist
        static let ROAD_ASSIST = "segueRoadAssist"
        static let ROAD_ASSIST_ADD = "segueAddRoadAssist"
        static let ROAD_ASSIST_INFO = "segueRoadAssistInfo"
        static let ROAD_ASSIST_EDIT_INFO = "segueEditExistingInfo"
        static let ROAD_ASSIST_UNWIND_EXIT = "unwindSegueFromRoadAssistEntry"
        
        //Auto Shop
        static let AUTO_SHOP = "segueAutoShop"
        static let AUTO_SHOP_ADD = "segueAddAutoShop"
        static let AUTO_SHOP_EDIT_INFO = "segueAutoShopEditInfo"
        static let AUTO_SHOP_INFO = "segueAutoShopInfo"
        static let AUTO_SHOP_UNWIND_EXIT = "unwindSegueFromAutoShopEntry"
    }
    
    struct ColorTheme {
        static let MY_VEHICLES = UIColor(red: 234/255.0, green: 167/255.0, blue: 46/255.0, alpha: 1.0)
        static let SERVICE_HISTORY = UIColor(red: 255/255.0, green: 142/255.0, blue: 0/255.0, alpha: 1.0)
        static let MILEAGE_TRACKER = UIColor(red: 53/255.0, green: 155/255.0, blue: 213/255.0, alpha: 1.0)
        static let ROAD_ASSIST = UIColor(red: 76/255.0, green: 133/255.0, blue: 82/255.0, alpha: 1.0)
        static let AUTO_SHOP = UIColor(red: 196/255.0, green: 61/255.0, blue: 71/255.0, alpha: 1.0)
    }
}