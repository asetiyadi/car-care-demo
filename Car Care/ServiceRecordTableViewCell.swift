//
//  ServiceRecordTableViewCell.swift
//  Car Care
//
//  Created by Andi Setiyadi on 4/2/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit

class ServiceRecordTableViewCell: UITableViewCell {

    // MARK: Outlet
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var serviceMileageLabel: UILabel!
    @IBOutlet weak var serviceCostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
