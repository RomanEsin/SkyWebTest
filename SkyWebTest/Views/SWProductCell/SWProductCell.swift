//
//  SWProductCell.swift
//  SWProductCell
//
//  Created by Роман Есин on 19.08.2021.
//

import UIKit

class SWProductCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addedLabel: UILabel!

    @IBOutlet weak var ccalLabel: UILabel!
    @IBOutlet weak var ccalBackground: UIView!

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        ccalBackground.layer.cornerRadius = 8
        accessoryType = .disclosureIndicator
    }

    func loadProduct(_ product: SWProduct) {
        ccalBackground.backgroundColor = product.colorForCcal().withAlphaComponent(0.4)
        nameLabel.text = product.name
        addedLabel.text = "Date: \(dateFormatter.string(from: product.date))"
        ccalLabel.text = "\(product.ccal) ccal"
    }
}
