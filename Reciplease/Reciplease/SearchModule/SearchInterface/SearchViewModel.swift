//
//  SearchViewModel.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 18/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

class SearchViewModel {
    var reloadHandler: () -> Void = {}
    var recipeHandler: () -> Void = {}
    var errorHandler: (_ message: String) -> Void = {_ in }

    private(set) var recipes = [Hit]()
    var ingredients: [String] = [] {
        didSet {
            reloadHandler()
        }
    }

    private var alamofireRequest: NetworkRequest

    init(alamofireRequest: NetworkRequest) {
        self.alamofireRequest = alamofireRequest
    }
}

extension SearchViewModel {
    func addIngredient(_ ingredient: String) {
        ingredients.append(ingredient)
    }
    func removeAllIngredients() {
        recipes.removeAll()
        ingredients.removeAll()
    }
    func ingredient(at indexPath: IndexPath) -> String {
        let index = indexPath.row
        let ingredient = ingredients[index]
        return ingredient
    }
    func removeIngredient(at indexPath: IndexPath) {
        let index = indexPath.row
        ingredients.remove(at: index)
    }
    var ingredientsCount: Int {
        ingredients.count
    }
}

extension SearchViewModel {
    func getRecipe() {
        let url = URL(string: "https://api.edamam.com/search")!
        let ingredientsString = ingredients.joined(separator: "+")
        let ingredientsModel = IngredientsModel(ingredients: ingredientsString)
        let parameters = ingredientsModel.values
        alamofireRequest.get(url, with: parameters) { (_ result: Result<RecipeData, Error>) in
            switch result {
            case .success(let data):
                self.recipes = data.hits
                self.recipeHandler()
            case .failure:
                print("erreur")
            }
        }
    }
}
