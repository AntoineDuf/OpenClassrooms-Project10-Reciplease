//
//  FavoriteViewModelTestsCase.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 10/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class FavoriteViewModelTestsCase: XCTestCase {
    var viewModel: FavoriteViewModel!
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    var myRecipes: [MyRecipe]!

    override func setUp() {
        super.setUp()
        //Given
        myRecipes = []
        createCoredataRecipe()
        viewModel = FavoriteViewModel(myRecipes: myRecipes, coreDataStack: coreDataStack)
    }

    override func tearDown() {
        viewModel = nil
        coreDataStack = nil
        coreDataManager = nil
        super.tearDown()
    }

    func testGivenThereIsOneRecipe_WhenRecipesCountIsCall_ThenMethodReturnOne() {
        //When
        let count = viewModel.recipesCount
        //Then
        XCTAssertEqual(count, 1)
    }

    func testGivenThereIsOneRecipe_WhenFirstRecipeURLIsCall_ThenMethodReturnTheRightStringURL() {
        //When
        let recipeURLString = viewModel.recipeURL(at: IndexPath(row: 0, section: 1))
        //Then
        XCTAssertEqual(recipeURLString, "https://www.atelierdeschefs.fr/fr/recette/")
    }

    func testGivenThereIsOneRecipe_WhenFirstRecipeIsCall_ThenMethodReturnRecipe() {
        //When
        let recipe = viewModel.recipe(at: IndexPath(row: 0, section: 1))
        //Then
        XCTAssertNotNil(recipe)
    }

    func testGivenThereIsOneRecipe_WhenFirstRecipeIsSelect_ThenMethodSetTheSelectedRecipe() {
        //When
        viewModel.didSelectRecipe(at: IndexPath(row: 0, section: 1))
        //Then
        XCTAssertNotNil(viewModel.selectedRecipe)
    }

    func testGivenThereIsOneRecipeInCoredata_WhenReloadRecipesIsCall_ThenMyRecipesHaveOneValue() {
        //When
        viewModel.reloadRecipes()
        //Then
        XCTAssertEqual(viewModel.myRecipes.count, 1)
    }
}

extension FavoriteViewModelTestsCase {

    func createCoredataRecipe() {
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        coreDataManager.makeRecipe(name: "Tomate mozzarella",
                                   totalTime: 10,
                                   image: "https://www.google.com",
                                   url: "https://www.atelierdeschefs.fr/fr/recette/")
        myRecipes.append(coreDataManager.recipes[0])
    }
}
