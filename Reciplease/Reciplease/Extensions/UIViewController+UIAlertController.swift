//
//  UIViewController+UIAlertController.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 20/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

extension UIViewController {
/// Method that permit to display the error alert window.
    func alert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
