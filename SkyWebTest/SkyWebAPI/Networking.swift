//
//  Networking.swift
//  Networking
//
//  Created by Роман Есин on 19.08.2021.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

class NetworkManager {
    static let session = URLSession.shared

    static func get<T: Decodable>(url: URL, decoder: JSONDecoder, _ completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)

        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        dataTask.resume()
    }
}
