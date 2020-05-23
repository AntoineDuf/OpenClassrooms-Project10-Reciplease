//
//  SearchViewModelTests.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 09/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import XCTest
import Alamofire
import Mockingjay
@testable import Reciplease

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var alamofireRequest: NetworkRequest!

    override func setUp() {
        super.setUp()
        alamofireRequest = FakeNetworkRequest(
            data: FakeResponseData.correctData,
            response: FakeResponseData.responseOK,
            error: nil
        )
        viewModel = SearchViewModel(alamofireRequest: alamofireRequest)
    }

    override func tearDown() {
        alamofireRequest = nil
        viewModel = nil
        super.tearDown()
    }

    func testGivenThereIsAnIngredientToAdd_WhenAddIngredientMethodIsCall_ThenTheRightIngredientIsAdd() {
        //When
        viewModel.addIngredient("Tomato")
        //Then
        XCTAssertNotNil(viewModel.ingredients)
        XCTAssertEqual(viewModel.ingredients[0], "Tomato")
    }

    func testGivenOneIngridientWasAdd_WhenRemoveAllIngredientMethodIsCall_ThenThereIsNoMoreIngredient() {
        //Given
        viewModel.addIngredient("Tomato")
        //When
        viewModel.removeAllIngredients()
        //Then
        XCTAssertTrue(viewModel.ingredients.isEmpty)
    }

    func testGivenThereAreIngredients_WhenIngredientMethodIsCall_ThenMethodReturnTheRightIngredient() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        viewModel.addIngredient("Tomato")
        //When
        let ingredient = viewModel.ingredient(at: indexPath)
        //Then
        XCTAssertEqual(ingredient, "Tomato")
    }

    func testGivenThereAreIngredients_WhenRemoveIngredientMethodIsCall_ThenMethodDeleteTheRightIngredient() {
        let indexPath = IndexPath(row: 0, section: 0)
        viewModel.addIngredient("Tomato")
        viewModel.removeIngredient(at: indexPath)
        XCTAssertTrue(viewModel.ingredients.isEmpty)
    }

    func testGivenThereIsOneIngredient_WhenIngredientsCountMethodIsCall_ThenMethodReturnOne() {
        //Given
        viewModel.addIngredient("Tomato")
        //When
        let count = viewModel.ingredientsCount
        //Then
        XCTAssertEqual(count, 1)
    }

    func testGetRecipeMethodPostSuccessCallbackIfNoErrorAndCorrectData() {
        viewModel.getRecipe()
        XCTAssertEqual(viewModel.recipes.count, 10)
    }

    func testGetRecipeMethodPostFailureCallbackIfNoErrorAndCorrectData() {
        alamofireRequest = FakeNetworkRequest(
            data: nil,
            response: FakeResponseData.responseKO,
            error: FakeResponseData.error
        )
        viewModel = SearchViewModel(alamofireRequest: alamofireRequest)
        viewModel.getRecipe()
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
}
