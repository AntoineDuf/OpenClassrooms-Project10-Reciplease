//
//  FakeNetworkRequest.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 13/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
@testable import Reciplease

struct FakeNetworkRequest: NetworkRequest {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    func get<RecipeData: Decodable>(
        _ url: URL,
        with: [String: Any],
        completion: @escaping (
        Result<RecipeData, Error>
        ) -> Void) {
        guard let response = response, response.statusCode == 200 else {
            return completion(.failure(NetworkRequestError.incorrectResponse))
        }
        guard let data = data else {
            return completion(.failure(NetworkRequestError.noData))
        }

        do {
            let responseJSON = try JSONDecoder().decode(RecipeData.self, from: data)
            completion(.success(responseJSON))
        } catch {
            completion(.failure(NetworkRequestError.undecodable))
        }
    }

    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
}
