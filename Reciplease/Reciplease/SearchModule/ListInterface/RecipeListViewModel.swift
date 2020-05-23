//
//  RecipeListViewModel.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 21/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

class RecipeListViewModel {
    var recipes: [Hit]
    private(set) var selectedRecipe: Hit?

    init(recipes: [Hit]) {
        self.recipes = recipes
    }
}

extension RecipeListViewModel {
    var recipesCount: Int {
        recipes.count
    }

    func recipeURL(at indexPath: IndexPath) -> String {
        let index = indexPath.row
        return recipes[index].recipe.url
    }

    func recipe(at indexPath: IndexPath) -> Hit {
        let index = indexPath.row
        return recipes[index]
    }

    func didSelectRecipe(at indexPath: IndexPath) {
        let index = indexPath.row
        selectedRecipe = recipes[index]
    }
}
