//
//  WebViewController.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 24/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var viewModel: WebViewModel!

    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = viewModel.getUrl()
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
    }

    @IBAction func favoriteButton(_ sender: Any) {
        viewModel.saveRecipe()
    }
}
