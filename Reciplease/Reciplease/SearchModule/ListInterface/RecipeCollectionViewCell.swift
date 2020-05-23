//
//  RecipeCollectionViewCell.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 22/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    private let stack = CoreDataManager(coreDataStack: CoreDataStack.init(modelName: "Reciplease"))

    @IBOutlet weak var collectionCellImage: UIImageView!
    @IBOutlet weak var collectionCellLabel: UILabel!
    @IBOutlet weak var collectionCellTimeLabel: UILabel!
    @IBOutlet weak var collectionCellHeartImage: UIImageView!

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
        let recipeName = recipe.recipe.label
        collectionCellLabel.text = recipeName
        collectionCellTimeLabel.text = setTime(time: recipe.recipe.totalTime)
        collectionCellHeartImage.image = setHeartImage(name: recipeName)
        if let url = URL(string: recipe.recipe.image) {
            if let data = try? Data(contentsOf: url) {
                collectionCellImage.image = UIImage(data: data)
            }
        }
    }

    func setTime(time: Double) -> String {
        let recipeTime: String
        if time == 0 {
            recipeTime = "n/c"
            return recipeTime
        }
        let timeInSeconds = time * 60
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        recipeTime = formatter.string(from: TimeInterval(timeInSeconds))!
        return recipeTime
    }

    func setHeartImage(name recipe: String) -> UIImage {
        if stack.checkIfRecipeIsFavorite(recipeTitle: recipe) {
            return Asset.heartFill.image
        } else {
            return Asset.heart.image
        }
    }
}
