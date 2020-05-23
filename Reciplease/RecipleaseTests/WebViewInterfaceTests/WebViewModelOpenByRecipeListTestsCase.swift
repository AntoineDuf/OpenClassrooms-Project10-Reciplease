//
//  WebViewModelTestsCase.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 10/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
@testable import Reciplease

class WebViewModelOpenByRecipeListTestsCase: XCTestCase {
    var viewModel: WebViewModel!
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    var recipeList: [Hit]!
    var recipe: Hit!

    override func setUp() {
        super.setUp()
        initiateViewModelRecipe()
    }

        override func tearDown() {
        viewModel = nil
        coreDataStack = nil
        coreDataManager = nil
        recipeList = []
        recipe = nil
        super.tearDown()
    }

    func testGivenThereIsOneRecipe_WhenGetURLIsCall_ThenMethodReturnURLRequest() {
        //When
        let urlRequest = viewModel.getUrl
        //Then
        XCTAssertNotNil(urlRequest)
    }

    func testGivenTherIsOneRecipeDisplay_WhenSaveRecipeIsCall_ThenRecipeIsSaveInCoredata() {
        //When
        viewModel.saveRecipe()
        //Then
        XCTAssertNotNil(coreDataManager.recipes)
    }

    func testGivenTherIsOneRecipeDisplay_WhenDeletRecipeIsCall_ThenRecipeIsDeleteInCoredata() {
        //When
        viewModel.deleteRecipe()
        //Then
        XCTAssertTrue(coreDataManager.recipes.isEmpty)
    }

    func testGivenTherIsOneRecipeDisplay_WhenFavoriteButtonImageIsCall_ThenMethodReturnRightImage() {
        //When
        let image = viewModel.favoriteButtonImage
        //Then
        XCTAssertEqual(image, Asset.heart.image)
    }
}

extension WebViewModelOpenByRecipeListTestsCase {
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
