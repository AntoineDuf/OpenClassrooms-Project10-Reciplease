//
//  WebViewModelTestsCase.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 10/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
@testable import Reciplease

class WebViewModelTestsCase: XCTestCase {
    var viewModel: WebViewModel!
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    var favoriteRecipe: MyRecipe!
    var recipeList: [Hit]!
    var recipe: Hit!

    override class func setUp() {
        super.setUp()
    }

    func testGetUrlOpenByRecipeList() {
        initiateViewModelRecipe()
        let urlRequest = viewModel.getUrl
        XCTAssertNotNil(urlRequest)
    }

    func testGetUrlOpenByFavoriteList() {
        initiateCoredataWithOneRecipe()
        initiateViewModelFavoriteRecipe()
        let urlRequest = viewModel.getUrl
        XCTAssertNotNil(urlRequest)
    }

    func testSaveRecipeOpenByRecipeList() {
        initiateViewModelRecipe()
        viewModel.saveRecipe()
        XCTAssertNotNil(coreDataManager.recipes)
    }

    func testSaveRecipeOpenByFavoriteList() {
        initiateCoredataWithOneRecipe()
        initiateViewModelFavoriteRecipe()
        viewModel.saveRecipe()
        XCTAssertNotNil(coreDataManager.recipes)
    }

    func testDeleteRecipeOpenByRecipeList() {
        initiateViewModelRecipe()
        viewModel.deleteRecipe()
        XCTAssertTrue(coreDataManager.recipes.isEmpty)
    }

    func testDeleteRecipeOpenByFavoriteList() {
        initiateCoredataWithOneRecipe()
        initiateViewModelFavoriteRecipe()
        viewModel.deleteRecipe()
        XCTAssertTrue(coreDataManager.recipes.isEmpty)
    }

    func testFavoriteButtonImageOpenByRecipeList() {
        initiateViewModelRecipe()
        let image = viewModel.favoriteButtonImage
        XCTAssertEqual(image, Asset.heart.image)
    }

    func testFavoriteButtonImageOpenByOpenByFavoriteList() {
        initiateCoredataWithOneRecipe()
        initiateViewModelFavoriteRecipe()
        let image = viewModel.favoriteButtonImage
        XCTAssertEqual(image, Asset.heartFill.image)
    }
}

extension WebViewModelTestsCase {
    func initiateCoredataWithOneRecipe() {
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        coreDataManager.makeRecipe(name: "Tomate mozzarella",
                                   totalTime: 10,
                                   image: "https://www.google.com",
                                   url: "https://www.atelierdeschefs.fr/fr/recette/")
        favoriteRecipe = coreDataManager.recipes[0]
    }

    func initiateViewModelFavoriteRecipe() {
        viewModel = WebViewModel(recipe: nil, favoriteRecipe: favoriteRecipe, openBy: .openByFavoriteList, stack: coreDataManager)
    }

    func initiateViewModelRecipe() {
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        putRecipe()
        recipe = recipeList[0]
        viewModel = WebViewModel(recipe: recipe, favoriteRecipe: nil, openBy: .openByRecipeList, stack: coreDataManager)
    }

    func putRecipe() {
        if let path = Bundle(for: type(of: self)).path(forResource: "Edamam", ofType: "json") {
            do {
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let responseJSON = try? JSONDecoder().decode(RecipeData.self, from: data!)
                recipeList = responseJSON!.hits
            }
        }
    }
}
