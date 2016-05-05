//
//  AutoModel+CoreDataProperties.swift
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

extension AutoModel {

    @NSManaged var model: String?
    @NSManaged var autoMaker: AutoMaker?
    @NSManaged var autoYear: NSSet?

}
