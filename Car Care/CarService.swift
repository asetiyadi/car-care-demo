//
//  CarService.swift
//  Car Care
//
//  Created by Andi Setiyadi on 3/30/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class CarService {
    
    internal var managedObjectContext: NSManagedObjectContext!
    
    internal init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    deinit {
        self.managedObjectContext = nil
    }
    
    internal func getMyVehicles() -> [Car] {
        var cars = [Car]()
        
        let request = NSFetchRequest(entityName: "Car")
        
        do {
            cars = try managedObjectContext.executeFetchRequest(request) as! [Car]
        }
        catch {
            fatalError("Error loading cars")
        }
        
        return cars
    }

    internal func deleteVehicle(car: Car) {
        managedObjectContext.deleteObject(car)
        saveState()
    }
    
    private func saveState() {
        do {
            try self.managedObjectContext.save()
        }
        catch {
            fatalError("Error inserting service record")
        }
    }
    
    func loadVehicleData() {
        // Need to set a privateContext to run on separately from the main thread so it will not hinder the UI interaction while the data store is loaded.
        let privateContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = CoreData().managedObjectContext.persistentStoreCoordinator
        
        Alamofire.request(.GET, "https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=6hpb5wfpnzecnubrar58w5tv")
            .response { request, response, data, error in
                /*print(request)
                 print(response)
                 print(data)
                 print(error)*/
                autoreleasepool({ 
                    if let urlContent = data {
                        do {
                            //let jsonResult = try? NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: []) as! NSDictionary
                            let jsonArray = jsonResult.valueForKey("makes") as! NSArray
                            
                            // Loop through AutoModel
                            for json in jsonArray {
                                guard let makeName = json["name"] as? String else { return }
                                
                                let autoMaker = NSEntityDescription.insertNewObjectForEntityForName("AutoMaker", inManagedObjectContext: privateContext) as! AutoMaker
                                autoMaker.make = makeName
                                
                                // Get the current AutoModels under the current AutoMaker
                                let autoModels = autoMaker.autoModel!.mutableCopy() as! NSMutableSet
                                
                                // Get the available AutoModel in JSON object for the current AutoMaker
                                guard let arrModelNames = json["models"] as? NSArray else { return }
                                for jsonModel in arrModelNames {
                                    let modelName = jsonModel["name"] as? String
                                    
                                    let autoModel = NSEntityDescription.insertNewObjectForEntityForName("AutoModel", inManagedObjectContext: privateContext) as! AutoModel
                                    
                                    autoModel.model = modelName
                                    
                                    
                                    let autoYears = autoModel.autoYear!.mutableCopy() as! NSMutableSet
                                    
                                    guard let arrModelYears = jsonModel["years"] as? NSArray else { return }
                                    for jsonYear in arrModelYears {
                                        let year = jsonYear["year"] as? NSNumber
                                        
                                        let autoYear = NSEntityDescription.insertNewObjectForEntityForName("AutoYear", inManagedObjectContext: privateContext) as! AutoYear
                                        autoYear.year = year
                                        autoYears.addObject(autoYear)
                                    }
                                    
                                    // Set AutoYear into AutoModel for CoreData
                                    autoModel.autoYear = autoYears.copy() as? NSSet
                                    
                                    autoModels.addObject(autoModel)
                                }
                                
                                // Set the AutoModel into AutoMaker for CoreData
                                autoMaker.autoModel = autoModels.copy() as? NSSet
                            }
                            
                            try privateContext.save()
                        }
                        catch {
                            print("error parsing json")
                        }
                        
                        self.checkVehicleData()
                    }
                })
                
        }
    }
    
    func checkVehicleData() {
        let makerRequest = NSFetchRequest(entityName: "AutoMaker")
        let modelRequest = NSFetchRequest(entityName: "AutoModel")
        let yearRequest = NSFetchRequest(entityName: "AutoYear")
        
        let makerCount = managedObjectContext.countForFetchRequest(makerRequest, error: nil)
        print("Total maker on checking: \(makerCount)")
        
        let modelCount = managedObjectContext.countForFetchRequest(modelRequest, error: nil)
        print("Total model on checking: \(modelCount)")
        
        let yearCount = managedObjectContext.countForFetchRequest(yearRequest, error: nil)
        print("Total year on checking: \(yearCount)")
    }
    
    func deleteVehicleData() {
        let coreData = CoreData()
        let makerRequest = NSFetchRequest(entityName: "AutoMaker")
        let modelRequest = NSFetchRequest(entityName: "AutoModel")
        let yearRequest = NSFetchRequest(entityName: "AutoYear")
        //let carRequest = NSFetchRequest(entityName: "Car")
        
        do {
            let makerResult = try coreData.managedObjectContext.executeFetchRequest(makerRequest) as! [AutoMaker]

            for maker in makerResult {
                coreData.managedObjectContext.deleteObject(maker)
            }
            
            let modelResult = try coreData.managedObjectContext.executeFetchRequest(modelRequest) as! [AutoModel]
            for model in modelResult {
                coreData.managedObjectContext.deleteObject(model)
            }
            
            let yearResult = try coreData.managedObjectContext.executeFetchRequest(yearRequest) as! [AutoYear]
            for year in yearResult {
                coreData.managedObjectContext.deleteObject(year)
            }
            
            coreData.saveContext()
            
            let makerCount = coreData.managedObjectContext.countForFetchRequest(makerRequest, error: nil)
            print("Total maker after clean up: \(makerCount)")
        }
        catch {
            fatalError("Error deleting objects")
        }
    }
}

