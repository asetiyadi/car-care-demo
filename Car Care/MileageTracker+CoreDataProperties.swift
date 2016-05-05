//
//  MileageTracker+CoreDataProperties.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/12/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MileageTracker {

    @NSManaged var date: NSDate?
    @NSManaged var gallonFilled: NSNumber?
    @NSManaged var odometer: NSNumber?
    @NSManaged var pricePerGal: NSNumber?
    @NSManaged var car: Car?

}
