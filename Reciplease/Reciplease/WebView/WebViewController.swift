//
//  WebViewController.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 24/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class WebViewController: UIViewController {
    var viewModel: WebViewModel!

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = viewModel.getUrl
        webView.load(request)
        favoriteButton.image = viewModel.favoriteButtonImage
    }

    @IBAction func favoriteButton(_ sender: Any) {
        if favoriteButton.image == UIImage(named: Asset.heart.name) {
            viewModel.saveRecipe()
            favoriteButton.image = UIImage(named: Asset.heartFill.name)
        } else {
            viewModel.deleteRecipe()
            favoriteButton.image = UIImage(named: Asset.heart.name)
        }
    }
}
