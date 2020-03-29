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
    private var ingredients: [String] = [] {
        didSet {
            reloadHandler()
        }
    }

    private let recipeService: RecipeService

    init(recipeService: RecipeService = .init()) {
        self.recipeService = recipeService
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
        let ingredientsString = ingredients.joined(separator: "+")
        recipeService.getRecipeFromAPI(ingredients: ingredientsString) { (data, error) in
            guard let data = data else {
                let message = error?.localizedDescription ?? "Une erreur est survenue."
                return self.errorHandler(message)
            }
            self.recipes = data.hits
            self.recipeHandler()
        }
    }
}
