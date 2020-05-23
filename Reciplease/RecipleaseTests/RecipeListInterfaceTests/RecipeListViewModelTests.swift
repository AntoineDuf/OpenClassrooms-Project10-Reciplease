//
//  RecipeListViewModelTests.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 09/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeListViewModelTests: XCTestCase {
    var viewModel: RecipeListViewModel!
    var recipes: [Hit] = []

    override func setUp() {
        super.setUp()
        viewModel = RecipeListViewModel(recipes: recipes)
        addRecipe()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testGivenThereAreRecipes_WhenRecipesCountIsCall_ThenMethodReturnTen() {
        //When
        let recipesCount = viewModel.recipesCount
        //Then
        XCTAssertEqual(recipesCount, 10)
    }

    func testGivenThereAreeRecipes_WhenFirstRecipeURLIsCall_ThenMethodReturnTheRightStringURL() {
        //When
        let recipeURL = viewModel.recipeURL(at: IndexPath(row: 0, section: 1))
        //Then
        XCTAssertEqual(recipeURL, "http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html")
    }

    func testGivenThereAreRecipes_WhenFirstRecipeIsCall_ThenMethodReturnTheRecipe() {
        //When
        let recipe = viewModel.recipe(at: IndexPath(row: 0, section: 1))
        //Then
        XCTAssertNotNil(recipe)
    }

    func testGivenThereAreRecipes_WhenFirstRecipeIsSelect_ThenMethodSetTheSelectedRecipe() {
        //When
        viewModel.didSelectRecipe(at: IndexPath(row: 0, section: 1))
        //Then
        XCTAssertEqual(viewModel.selectedRecipe?.recipe.label, "Chicken Vesuvio")
    }
}

extension RecipeListViewModelTests {
    func addRecipe() {
        if let path = Bundle(for: type(of: self)).path(forResource: "Edamam", ofType: "json") {
            do {
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let responseJSON = try? JSONDecoder().decode(RecipeData.self, from: data!)
                self.viewModel.recipes = responseJSON!.hits
            }
        }
    }
}
