//
//  MyVehicleViewModel.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/13/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

struct MyVehicleViewModel {
    
    var carService: CarService!
    var selectedCar: Car?
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        carService = CarService(managedObjectContext: managedObjectContext)
    }
    
    mutating func getCarDatasource() -> [Car] {
        selectedCar = nil
        var cars = carService.getMyVehicles()
        
        // If this is the first time users use the app and no vehicle is setup yet, create a dummy vehicle entry
        if cars.count == 0 {
            selectedCar = NSEntityDescription.insertNewObjectForEntityForName("Car", inManagedObjectContext: managedObjectContext) as? Car
            selectedCar!.name = Constant.SETUP_FIRST_CAR
            selectedCar!.image = UIImageJPEGRepresentation(UIImage(named: "camera")!, 1)
            
            cars.append(selectedCar!)
        }
        
        return cars
    }
    
    func deleteCar(car: Car) {
        carService.deleteVehicle(car)
    }
}