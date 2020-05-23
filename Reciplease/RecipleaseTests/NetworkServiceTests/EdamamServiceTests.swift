//
//  EdamamServiceTests.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 22/04/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

@testable import Reciplease
import XCTest
import Mockingjay
import Alamofire

@testable import Reciplease

class EdamamServiceTests: XCTestCase {

    let webService = RecipeService()
    let ingredients = IngredientsModel(ingredients: "Chicken")

    func testGetDataShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        if let path = Bundle(for: type(of: self)).path(forResource: "Edamam", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                stub(everything, json(jsonResult))
                let expectation = XCTestExpectation(description: "Alamofire")
                webService.getRecipeFromAPI(ingredients: ingredients) { (data, error) in
                    XCTAssertNotNil(data)
                    XCTAssertEqual(data?.hits.count, 10)
                    XCTAssertNil(error)
                    expectation.fulfill()
                }
                wait(for: [expectation], timeout: 1)
            } catch {
                XCTAssertTrue(false, "Could not read json from file FakeRecipe.json")
            }
        }
    }

    func testGetDataShouldPostFailedCallbackIfError() {
        stub(everything, http(404))
        let expectation = XCTestExpectation(description: "Alamofire")
        webService.getRecipeFromAPI(ingredients: ingredients) { (data, error) in
            XCTAssertNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
