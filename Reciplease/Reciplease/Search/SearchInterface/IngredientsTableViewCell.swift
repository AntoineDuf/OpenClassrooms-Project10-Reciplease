//
//  IngredientsTableViewCell.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 20/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellView: UIView!

    func configureCell(ingredient: String) {
        cellLabel.text = ingredient
    }
}
