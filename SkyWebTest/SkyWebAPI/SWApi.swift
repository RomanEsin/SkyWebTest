//
//  SkyWebAPI.swift
//  SkyWebAPI
//
//  Created by Роман Есин on 19.08.2021.
//

import Foundation

class SWApi {

    static let baseURL = URL(string: "http://62.109.7.98/api/")!

    static let dateFormatterFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'mm:HH:ss.SSSSSS'Z'"
        return formatter
    }()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let decodedDate: Date?

            if dateStr.count == 10 {
                decodedDate = dateFormatter.date(from: dateStr)
            } else {
                decodedDate =  dateFormatterFull.date(from: dateStr)
            }

            guard let date = decodedDate else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date: \(dateStr)")
            }

            return date
        })
        return decoder
    }()

    static func getProduct(_ productId: Int, completion: @escaping (Result<SWResponse<SWProduct>, Error>) -> Void) {
        let url = baseURL
            .appendingPathComponent("product")
            .appendingPathComponent(String(productId))

        NetworkManager.get(url: url, decoder: decoder, completion)
    }

    static func getCategoryProducts(_ categoryId: Int, completion: @escaping (Result<SWResponse<[SWProduct]>, Error>) -> Void) {
        let url = baseURL
            .appendingPathComponent("product")
            .appendingPathComponent("category")
            .appendingPathComponent(String(categoryId))

        NetworkManager.get(url: url, decoder: decoder, completion)
    }

    static func getCategories(completion: @escaping (Result<SWResponse<[SWCategory]>, Error>) -> Void) {
        let url = baseURL
            .appendingPathComponent("categories")

        NetworkManager.get(url: url, decoder: decoder, completion)
    }
}
