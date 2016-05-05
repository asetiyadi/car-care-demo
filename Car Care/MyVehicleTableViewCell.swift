//
//  MyVehicleTableViewCell.swift
//  Car Care
//
//  Created by Andi Setiyadi on 3/30/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit

class MyVehicleTableViewCell: UITableViewCell {
    
    var car: Car!
    
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carYearLabel: UILabel!
    @IBOutlet weak var carMakeLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carSubmodelLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
