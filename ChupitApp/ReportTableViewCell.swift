//
//  ReportTableViewCell.swift
//  ChupitApp
//
//  Created by Marco Falanga on 12/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chupitosLabel: UILabel!
    @IBOutlet weak var consecutiveLabel: UILabel!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var chupitoCounterLabel: UILabel!
    @IBOutlet weak var chupitoImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
