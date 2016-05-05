//
//  CarOptionTableViewModel.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/14/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import Foundation
import CoreData

struct CarOptionTableViewModel {
    
    var managedObjectContext: NSManagedObjectContext
    var carService: CarService?
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        carService = CarService(managedObjectContext: self.managedObjectContext)
    }
    
    /**
        To get the list of car make, model or year based on the parameter being passed to the function.
        - parameter specType: determine the type of information needed to display the selection,ie Make | Model | Year
        - parameter car: the car object needed to get the model and year for the selected car make
        - returns: a tuple containing the label and datasources
    */
    func getVehicleSelection(specType: String, car: Car) -> (textLabel: String, sources: [String]) {
        var data: (textLabel: String, sources: [String]) = ("", [])
        var list = [String]()
        
        switch specType.lowercaseString {
        case "make":
            data.textLabel = "Select Auto Maker"
            let fetchRequest = NSFetchRequest(entityName: "AutoMaker")
            
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                
                guard let autoMakers = results as? [AutoMaker] else { return data }
                for result in autoMakers {
                    list.append(result.make!)
                }
            }
            catch {
                fatalError("Error getting auto makers")
            }
            
        case "model":
            data.textLabel = "Select Model"
            let fetchRequest = NSFetchRequest(entityName: "AutoModel")
            fetchRequest.predicate = NSPredicate(format: "autoMaker.make = %@", car.make!)
            
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                
                guard let autoModels = results as? [AutoModel] else { return data }
                for result in autoModels {
                    list.append(result.model!)
                }
            }
            catch {
                fatalError("Error getting auto makers")
            }
            
        case "year":
            data.textLabel = "Select Year"
            let fetchRequest = NSFetchRequest(entityName: "AutoYear")
            fetchRequest.predicate = NSPredicate(format: "autoModel.model = %@", car.model!)
            
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                
                guard let autoYears = results as? [AutoYear] else { return data }
                for result in autoYears {
                    list.append(String(result.year!))
                }
            }
            catch {
                fatalError("Error getting auto makers")
            }
            
        default:
            print("No car spec is selected")
        }
        
        list.sortInPlace()
        
        data.sources = list
        
        return data
    }
    
    func updateCar(car: Car, specType: String, specValue: String) -> Car {

        switch specType.lowercaseString {
        case "make":
            car.make = specValue
            car.model = ""
            car.year = 0
        case "model":
            car.model = specValue
            car.year = 0
        case "year":
            car.year = Int(specValue)
        default:
            print("no spec type matches")
        }
        
        return car
    }
}
