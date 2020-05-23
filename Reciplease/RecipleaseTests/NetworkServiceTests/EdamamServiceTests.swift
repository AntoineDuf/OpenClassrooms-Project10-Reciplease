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

class EdamamServiceTests: XCTestCase {
    let webService = AlamofireNetworkRequest()
    let ingredients = IngredientsModel(ingredients: "")
    let url = URL(string: "www.google.com")!

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testGetDataShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let parameters = ingredients.values
        if let path = Bundle(for: type(of: self)).path(forResource: "Edamam", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                stub(everything, json(jsonResult))
                let expectation = XCTestExpectation(description: "Alamofire")
                webService.get(url, with: parameters) { (_ result: Result<RecipeData, Error>) in
                    switch result {
                    case .success(let data):
                        XCTAssertNotNil(data)
                        XCTAssertEqual(data.hits.count, 10)
                        XCTAssertEqual(data.hits[0].recipe.label, "Chicken Vesuvio")
                    case .failure:
                        print("error should not have error")
                    }
                    expectation.fulfill()
                }
                wait(for: [expectation], timeout: 1)
            } catch {
                XCTAssertTrue(false, "Could not read json from file Edamam.json")
            }
        }
    }

    func testGetDataShouldPostFailedCallbackIfError() {
        let parameters = ingredients.values
        stub(everything, http(404))
        let expectation = XCTestExpectation(description: "Alamofire")
        webService.get(url, with: parameters) { (_ result: Result<RecipeData, Error>) in
            switch result {
            case .success:
                print("error should not have data")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
