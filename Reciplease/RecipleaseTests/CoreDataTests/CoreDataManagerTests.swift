//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 15/04/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
@testable import Reciplease

final class CoreDataManagerTests: XCTestCase {

    // MARK: - Properties

    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!

    // MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }

    func testAddRecipeMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.makeRecipe(name: "Tomate mozzarella",
                                     totalTime: 10,
                                     image: "https://www.google.com",
                                     url: "https://www.atelierdeschefs.fr/fr/recette/")
        XCTAssertFalse(coreDataManager.recipes.isEmpty)
        XCTAssertEqual(coreDataManager.recipes.count, 1)
        XCTAssertEqual(coreDataManager.recipes[0].name, "Tomate mozzarella")
        XCTAssertEqual(coreDataManager.recipes[0].time, 10)
        XCTAssertEqual(coreDataManager.recipes[0].image,"https://www.google.com")
        XCTAssertEqual(coreDataManager.recipes[0].url, "https://www.atelierdeschefs.fr/fr/recette/")
        let recipeIsFavorite = coreDataManager.checkIfRecipeIsFavorite(recipeTitle: "Tomate mozzarella")
        XCTAssertTrue(recipeIsFavorite)
    }

    func testDeleteRecipeMethod_WhenAnEntityExist_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.makeRecipe(name: "Tomate mozzarella",
        totalTime: 10,
        image: "https://www.google.com",
        url: "https://www.atelierdeschefs.fr/fr/recette/")
        XCTAssertFalse(coreDataManager.recipes.isEmpty)
        XCTAssertEqual(coreDataManager.recipes.count, 1)
        coreDataManager.deleteRecipe(recipeTitle: "Tomate mozzarella")
        XCTAssertTrue(coreDataManager.recipes.isEmpty)
        XCTAssertEqual(coreDataManager.recipes.count, 0)
    }
}
