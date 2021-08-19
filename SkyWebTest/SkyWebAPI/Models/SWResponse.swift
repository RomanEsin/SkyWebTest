//
//  SkyWebResponse.swift
//  SkyWebResponse
//
//  Created by Роман Есин on 19.08.2021.
//

import Foundation

struct SWResponse<T: Codable>: Codable {
    let data: T
}
