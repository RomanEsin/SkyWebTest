//
//  SWProduct.swift
//  SWProduct
//
//  Created by Роман Есин on 19.08.2021.
//

import Foundation
import UIKit

struct SWProduct: Codable, Identifiable, Hashable, Equatable {
    var id: Int
    let name: String
    let ccal: Int
    let categoryId: Int

    let date: Date
    let createdAt: Date
    let updatedAt: Date
}

extension SWProduct {
    func colorForCcal() -> UIColor {
        // Idk anything about calories so
        // here're just random values
        //        let max = 300
        let mid = 200
        let min = 100

        switch ccal {
        case 0...min:
            return .systemGreen
        case min...mid:
            return .systemYellow
        default:
            return .systemRed
        }
    }
}
