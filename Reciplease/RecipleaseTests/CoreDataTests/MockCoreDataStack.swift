//
//  MockCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 15/04/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Reciplease
import Foundation
import CoreData

final class MockCoreDataStack: CoreDataStack {

    // MARK: - Initializer

    convenience init() {
        self.init(modelName: "Reciplease")
    }

    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
