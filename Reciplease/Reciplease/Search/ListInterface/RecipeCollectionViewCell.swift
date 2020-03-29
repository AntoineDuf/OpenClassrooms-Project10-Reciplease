
//
//  RecipeCollectionViewCell.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 22/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionCellImage: UIImageView!
    @IBOutlet weak var collectionCellLabel: UILabel!
    @IBOutlet weak var collectionCellTimeLabel: UILabel!

    func configureCell(recipe: Hit) {
        configureStyleCell()
        configureContentCell(recipe: recipe)
    }

    func configureStyleCell() {
        collectionCellImage.layer.shadowColor = UIColor.black.cgColor
        collectionCellImage.layer.shadowOpacity = 1
        collectionCellImage.layer.shadowOffset = .zero
        collectionCellImage.layer.shadowRadius = 20
    }

    func configureContentCell(recipe: Hit) {
        collectionCellLabel.text = recipe.recipe.label
        collectionCellTimeLabel.text = setTime(time: recipe.recipe.totalTime)
        if let url = URL(string: recipe.recipe.image) {
            if let data = try? Data(contentsOf: url) {
                collectionCellImage.image = UIImage(data: data)
            }
        }
    }

    func setTime(time: Double) -> String {
        let recipeTime = time == 0 ? "n/c" : "\(String(Int(time))) min"
        return recipeTime
    }
}
