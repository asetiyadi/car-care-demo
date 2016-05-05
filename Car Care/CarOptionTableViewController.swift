//
//  CarOptionTableViewController.swift
//  Car Care
//
//  Created by Andi Setiyadi on 3/31/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

protocol CarSpecsDelegate {
    func updateCar(car: Car)
}

class CarOptionTableViewController: UITableViewController {
    
    // MARK: Properties
    var selectedCarSpecType: String!
    var managedObjectContext: NSManagedObjectContext!
    var delegate: CarSpecsDelegate!
    var car: Car!
    var viewModel: CarOptionTableViewModel!
    
    var list = [String]()
    
    @IBOutlet weak var menuLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CarOptionTableViewModel(managedObjectContext: managedObjectContext)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        list.removeAll()
        loadOption()
    }
    
    func loadOption() {
        let data = viewModel.getVehicleSelection(selectedCarSpecType, car: car)
        
        menuLabel.text = data.textLabel
        list = data.sources

        tableView.reloadData()
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellOption", forIndexPath: indexPath)

        cell.textLabel?.text = list[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        car = viewModel.updateCar(car, specType: selectedCarSpecType, specValue: list[indexPath.row])
        delegate.updateCar(car)

        dismissViewControllerAnimated(true, completion: nil)
    }
}
