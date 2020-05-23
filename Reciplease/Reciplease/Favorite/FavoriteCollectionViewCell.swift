//
//  FavoriteCollectionViewCell.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 30/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionCellImage: UIImageView!
    @IBOutlet weak var collectionCellLabel: UILabel!
    @IBOutlet weak var collectionCellTimeLabel: UILabel!
    @IBOutlet weak var collectionCellHeartImage: UIImageView!

    func configureCell(recipe: MyRecipe) {
        configureStyleCell()
        configureContentCell(recipe: recipe)
    }

    func configureStyleCell() {
        collectionCellImage.layer.shadowColor = UIColor.black.cgColor
        collectionCellImage.layer.shadowOpacity = 1
        collectionCellImage.layer.shadowOffset = .zero
        collectionCellImage.layer.shadowRadius = 20
    }

    func configureContentCell(recipe: MyRecipe) {
        collectionCellLabel.text = recipe.name
        collectionCellTimeLabel.text = setTime(time: recipe.time)
        if let url = URL(string: recipe.image!) {
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
