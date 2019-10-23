//
//  CustomCell.swift
//  KeepChild
//
//  Created by Clément Martin on 19/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var imageProfil: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var semaineDayLabel: UILabel!
    @IBOutlet weak var momentDayLabel: UILabel!

}

class CellLocation: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
        accessoryType = .checkmark
    }
}

class CellTextField: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var textField: UITextField!
}

class CellImageView: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var imageViewProfil: UIImageView!
}
