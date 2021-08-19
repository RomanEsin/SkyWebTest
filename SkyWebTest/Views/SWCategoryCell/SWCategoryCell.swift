//
//  SWCategoryCell.swift
//  SWCategoryCell
//
//  Created by Роман Есин on 19.08.2021.
//

import UIKit

class SWCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!

    @IBOutlet weak var countBackground: UIView!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        countBackground.layer.cornerRadius = 8
        accessoryType = .disclosureIndicator
    }

    func loadCategory(_ category: SWCategory) {
        categoryLabel.text = category.name
        unitLabel.text = category.unit + "s"
        countLabel.text = String(category.count)
    }
}
