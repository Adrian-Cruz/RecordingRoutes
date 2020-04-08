//
//  RouteTableViewCell.swift
//  RecordingRoutes
//
//  Created by Adrian on 03/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var imageRoute: UIImageView!
    @IBOutlet weak var labelNameRoute: UILabel!
    @IBOutlet weak var labelInitialDateRoute: UILabel!
    
    var routeViewModel : RouteViewModel! {
        didSet {
            labelNameRoute.text = routeViewModel.name
            labelInitialDateRoute.text = routeViewModel.initialTimeString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
