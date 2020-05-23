//
//  WebViewModelOpenByFavoriteListTestsCase.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 18/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
@testable import Reciplease

class WebViewModelOpenByFavoriteListTestsCase: XCTestCase {
        var viewModel: WebViewModel!
        var coreDataStack: MockCoreDataStack!
        var coreDataManager: CoreDataManager!
        var favoriteRecipe: MyRecipe!

        override func setUp() {
            super.setUp()
            initiateViewModelOpenByFavoriteList()
        }

    override func tearDown() {
        viewModel = nil
        coreDataStack = nil
        coreDataManager = nil
        favoriteRecipe = nil
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
            XCTAssertEqual(image, Asset.heartFill.image)
        }
    }

extension WebViewModelOpenByFavoriteListTestsCase {
        func initiateCoredataWithOneRecipe() {
            coreDataStack = MockCoreDataStack()
            coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
            coreDataManager.makeRecipe(name: "Tomate mozzarella",
                                       totalTime: 10,
                                       image: "https://www.google.com",
                                       url: "https://www.atelierdeschefs.fr/fr/recette/")
            favoriteRecipe = coreDataManager.recipes[0]
        }

        func initiateViewModelOpenByFavoriteList() {
            initiateCoredataWithOneRecipe()
            viewModel = WebViewModel(
                recipe: nil,
                favoriteRecipe: favoriteRecipe,
                openBy: .openByFavoriteList,
                stack: coreDataManager
            )
        }
    }
