//
//  WebViewModel.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 31/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WebViewModel {
    let recipe: Hit?
    let favoriteRecipe: MyRecipe?
    private var openBy: State
    var url: String?
    private let stack: CoreDataManager

    init(recipe: Hit?,
         favoriteRecipe: MyRecipe?,
         openBy: State,
         stack: CoreDataManager = CoreDataManager(coreDataStack: .init(modelName: "Reciplease"))) {
        self.recipe = recipe
        self.favoriteRecipe = favoriteRecipe
        self.openBy = openBy
        self.stack = stack
    }

    var getUrl: URLRequest {
        let request: URLRequest
        let url: URL
        switch openBy {
        case .openByFavoriteList:
            url = URL(string: (favoriteRecipe?.url)!)!
        case .openByRecipeList:
            url = URL(string: (recipe?.recipe.url)!)!
        }
        request = URLRequest(url: url)
        return request
    }

    func saveRecipe() {
        switch openBy {
        case .openByFavoriteList:
            guard let recipe = favoriteRecipe else { return }
            stack.makeRecipe(name: recipe.name!, totalTime: recipe.time, image: recipe.image!, url: recipe.url!)
        case .openByRecipeList:
            guard let recipe = self.recipe?.recipe else { return }
            stack.makeRecipe(name: recipe.label, totalTime: recipe.totalTime, image: recipe.image, url: recipe.url)
        }
    }

    enum State {
        case openByRecipeList
        case openByFavoriteList
    }

    func deleteRecipe() {
        let recipeName: String
        switch openBy {
        case .openByFavoriteList:
            guard let name = favoriteRecipe?.name else { return }
            recipeName = name
        case .openByRecipeList:
            guard let name = recipe?.recipe.label else { return }
            recipeName = name
        }
        stack.deleteRecipe(recipeTitle: recipeName)
    }

    var favoriteButtonImage: UIImage {
        let optionalName: String?
        switch openBy {
        case .openByFavoriteList:
            optionalName = favoriteRecipe?.name
        case .openByRecipeList:
            optionalName = recipe?.recipe.label
        }
        guard let name = optionalName else { return Asset.heart.image }
        let isRecipeInDatabase = self.isRecipeInDatabase(for: name)
        let heartImage = isRecipeInDatabase ? Asset.heartFill.image : Asset.heart.image
        return heartImage
    }

    private func isRecipeInDatabase(for name: String) -> Bool {
        return stack.checkIfRecipeIsFavorite(recipeTitle: name)
    }
}
