//
//  RecipeData.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 18/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

struct RecipeData: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    let totalTime: Double
}
