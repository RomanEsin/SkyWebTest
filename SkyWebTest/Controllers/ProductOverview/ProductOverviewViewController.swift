//
//  ProductOverviewViewController.swift
//  ProductOverviewViewController
//
//  Created by Роман Есин on 19.08.2021.
//

import UIKit

class ProductOverviewViewController: UIViewController {

    var product: SWProduct?
    var category: SWCategory?

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!

    @IBOutlet weak var ccalBackground: UIView!
    @IBOutlet weak var ccalLabel: UILabel!

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM d"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let category = category {
            categoryLabel.text = category.name
        }

        if let product = product {
            productNameLabel.text = product.name
            ccalLabel.text = "\(product.ccal) ccal"
            ccalBackground.backgroundColor = product.colorForCcal().withAlphaComponent(0.4)

            dateLabel.text = "Date: \(dateFormatter.string(from: product.date))"
            createdLabel.text = "Created at: \(dateFormatter.string(from: product.createdAt))"
            updatedLabel.text = "Updated at: \(dateFormatter.string(from: product.updatedAt))"
        }

        // Init styles
        ccalBackground.layer.cornerRadius = 8

        productNameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        productNameLabel.layer.shadowRadius = 12
        productNameLabel.layer.shadowColor = UIColor.black.cgColor
        productNameLabel.layer.shadowOpacity = 1
        productNameLabel.layer.shadowOffset = .zero
        productNameLabel.layer.masksToBounds = false
    }

    func loadProduct(_ product: SWProduct, category: SWCategory?) {
        self.product = product
        self.category = category
    }

}
