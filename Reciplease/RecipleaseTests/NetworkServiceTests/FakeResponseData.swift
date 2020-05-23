//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Antoine Dufayet on 13/05/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

class FakeResponseData {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "test")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
        )!
    static let responseKO = HTTPURLResponse(
        url: URL(string: "test")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil
        )!

    class APIsError: Error {}
    static let error = APIsError()

    static var correctData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Edamam", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        return data
    }

    static let incorrectData = "erreur".data(using: .utf8)
}
