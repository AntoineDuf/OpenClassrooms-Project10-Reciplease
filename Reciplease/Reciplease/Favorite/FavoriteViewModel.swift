//
//  FavoriteViewModel.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 30/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
// swiftlint:disable force_try

import Foundation
import CoreData

class FavoriteViewModel {
    private(set) var myRecipes: [MyRecipe]
    private let coreDataStack: CoreDataStack
    private(set) var selectedRecipe: MyRecipe?

    init(myRecipes: [MyRecipe], coreDataStack: CoreDataStack) {
        self.myRecipes = myRecipes
        self.coreDataStack = coreDataStack
    }
}

extension FavoriteViewModel {
    func reloadRecipes() {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        myRecipes = try! coreDataStack.mainContext.fetch(request)
    }
}

extension FavoriteViewModel {
    var recipesCount: Int {
        myRecipes.count
    }

    func recipeURL(at indexPath: IndexPath) -> String {
        let index = indexPath.row
        return myRecipes[index].url!
    }

    func recipe(at indexPath: IndexPath) -> MyRecipe {
        let index = indexPath.row
        return myRecipes[index]
    }

    func didSelectRecipe(at indexPath: IndexPath) {
        let index = indexPath.row
        selectedRecipe = myRecipes[index]
    }
}
