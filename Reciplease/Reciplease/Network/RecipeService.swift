//
//  RecipeService.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 18/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkRequestError: Error {
    case noData
    case incorrectResponse
    case undecodable
}

public protocol NetworkRequest {
    func get<DataType: Decodable>(
        _ url: URL,
        with parameters: [String: Any],
        completion: @escaping (Result<DataType, Error>) -> Void
    )
}

class AlamofireNetworkRequest: NetworkRequest {
    func get<RecipeData: Decodable>(
        _ url: URL,
        with parameters: [String: Any],
        completion: @escaping (Result<RecipeData, Error>) -> Void
    ) {
        Alamofire.AF.request(
            url,
            parameters: parameters
        ).responseJSON { responseData in
            guard let data = responseData.data,
                responseData.response?.statusCode == 200,
                let responseJSON = try? JSONDecoder().decode(RecipeData.self, from: data)
                else {
                    completion(.failure(NetworkRequestError.incorrectResponse))
                    return
            }
            completion(.success(responseJSON))
        }
    }
}

struct IngredientsModel: Encodable {
    let ingredients: String
    let appID = "36f7a527"
    let apiKey = "a4ea968a0a0e8cbe82e048618a52fa42"
    let toTen = "10"

    var values: [String: Any] {
        return ["q": ingredients, "app_id": appID, "app_key": apiKey, "to": toTen]
    }

    enum CodingKeys: String, CodingKey {
        case ingredients = "q"
        case appID = "app_id"
        case apiKey = "app_key"
        case toTen = "to"
    }
}
