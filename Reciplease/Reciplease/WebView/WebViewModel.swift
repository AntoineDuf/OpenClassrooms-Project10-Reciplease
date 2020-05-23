//
//  WebViewModel.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 31/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import CoreData

struct WebViewModel {
    private let recipe: Hit
    var openBy: State

    init(recipe: Hit, openBy: State) {
        self.recipe = recipe
        self.openBy = openBy
    }

    func getUrl() -> String {
        return recipe.recipe.url
    }

    func saveRecipe() {
        let myRecipe = MyRecipe(context: AppDelegate.viewContext)
        myRecipe.name = recipe.recipe.label
        myRecipe.time = recipe.recipe.totalTime
        myRecipe.image = recipe.recipe.image
        myRecipe.url = recipe.recipe.url
        try? AppDelegate.viewContext.save()
    }
    
    enum State {
        case openByRecipeList
        case openByFavoriteList
    }
}
