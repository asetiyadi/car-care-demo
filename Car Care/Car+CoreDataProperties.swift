//
//  Car+CoreDataProperties.swift
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

extension Car {

    @NSManaged var image: NSData?
    @NSManaged var make: String?
    @NSManaged var model: String?
    @NSManaged var name: String?
    @NSManaged var registerMileage: NSNumber?
    @NSManaged var submodel: String?
    @NSManaged var year: NSNumber?
    @NSManaged var avgMilePerDay: NSNumber?
    @NSManaged var mileageTracker: NSSet?
    @NSManaged var service: NSSet?

}
