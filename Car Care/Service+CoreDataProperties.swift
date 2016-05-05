//
//  Service+CoreDataProperties.swift
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

extension Service {

    @NSManaged var cost: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var location: String?
    @NSManaged var mileage: NSNumber?
    @NSManaged var note: String?
    @NSManaged var type: String?
    @NSManaged var car: Car?

}
