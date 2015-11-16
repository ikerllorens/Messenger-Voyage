//
//  VehicleCollectionViewCell.swift
//  UltraDelivery
//
//  Created by Iker on 15/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class VehicleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    var vehicleInfo: NSDictionary!
}
