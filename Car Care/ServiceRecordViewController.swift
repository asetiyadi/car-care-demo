//
//  ServiceRecordViewController.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/1/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit
import CoreData

class ServiceRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlet
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noRecordsView: UIView!
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    var car: Car!
    var records = [Service]()
    var selectedRecord: Service?
    var maintenanceService: MaintenanceService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carNameLabel.text = car.name
        
        maintenanceService = MaintenanceService(managedObjectContext: managedObjectContext)
        
        //guard let year = car.year else { return }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        records = maintenanceService.getServiceRecords(car.name!)
        tableview.reloadData()
        
        if records.count == 0 {
            tableview.tableFooterView = noRecordsView
            tableview.tableFooterView?.hidden = false
        }
        else {
            tableview.tableFooterView = UIView()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellServiceRecord", forIndexPath: indexPath) as! ServiceRecordTableViewCell
        
        cell.layer.shadowOffset = CGSizeMake(0, 1)
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 0.3
        
        cell.clipsToBounds = false
        
        let shadowFrame: CGRect = cell.layer.bounds
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        cell.layer.shadowPath = shadowPath
        
        
        let record = records[indexPath.row]
        cell.serviceTypeLabel.text = record.type
        
        /*let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.serviceDateLabel.text = dateFormatter.stringFromDate(record.date!)*/
        
        cell.serviceDateLabel.text = Utility.dateToString(record.date!)
        
        cell.serviceMileageLabel.text = String(record.mileage!)
        
        let cost = Double(record.cost!)
        cell.serviceCostLabel.text = String(Double(round(cost * 100)/100))
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRecord = records[indexPath.row]
        
        performSegueWithIdentifier(Constant.SegueIdentifier.SERVICE_RECORD_INFO_EDIT, sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let serviceInfoController = segue.destinationViewController as! ServiceInfoViewController
        serviceInfoController.managedObjectContext = managedObjectContext
        serviceInfoController.car = car
        
        if segue.identifier == Constant.SegueIdentifier.SERVICE_RECORD_INFO {
            serviceInfoController.isExistingRecord = false
        }
        else if segue.identifier == Constant.SegueIdentifier.SERVICE_RECORD_INFO_EDIT {
            serviceInfoController.selectedRecord = selectedRecord
            serviceInfoController.isExistingRecord = true
        }
    }
    

}
