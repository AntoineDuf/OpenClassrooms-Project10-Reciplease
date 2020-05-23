//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 15/04/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext

    var recipes: [MyRecipe] {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage Task Entity

    func makeRecipe(name: String, totalTime: Double, image: String, url: String) {
        let recipe = MyRecipe(context: managedObjectContext)
        recipe.name = name
        recipe.time = totalTime
        recipe.image = image
        recipe.url = url
        coreDataStack.saveContext()
    }

    func deleteRecipe(recipeTitle: String) {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", recipeTitle)

        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }

    func checkIfRecipeIsFavorite(recipeTitle: String) -> Bool {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", recipeTitle)

        guard let counter = try? managedObjectContext.count(for: request) else { return false }
        return counter == 0 ? false : true
    }
}
