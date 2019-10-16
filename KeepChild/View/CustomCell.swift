//
//  CustomCell.swift
//  KeepChild
//
//  Created by Clément Martin on 19/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var imageProfil: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CellLocation: UITableViewCell {
    
    //@IBOutlet weak var label: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // update UI
        accessoryType = selected ? .checkmark : .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
        accessoryType = .checkmark
    }
}

class CellTextField: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}

class CellImageView: UITableViewCell {
    @IBOutlet weak var imageViewProfil: UIImageView!
}
