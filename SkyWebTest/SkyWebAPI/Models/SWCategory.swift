//
//  SWCategory.swift
//  SWCategory
//
//  Created by Роман Есин on 19.08.2021.
//

import Foundation

struct SWCategory: Codable, Hashable, Equatable {
    let id: Int
    let name: String
    let unit: String
    let count: Int
}
