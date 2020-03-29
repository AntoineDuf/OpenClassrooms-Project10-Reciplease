//
//  RecipeListCollectionView.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 22/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class RecipeListCollectionViewController: UICollectionViewController {
    var viewModel: RecipeListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCellSize()
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.recipesCount
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "recipeCollectionCell",
            for: indexPath
            ) as? RecipeCollectionViewCell else { fatalError() }

        let recipe = viewModel.recipe(at: indexPath)
        cell.configureCell(
            recipe: recipe
        )
        return cell
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let webVC = storyboard?.instantiateViewController(
            withIdentifier: "WebViewController"
            ) as? WebViewController else { return }

        webVC.url = viewModel.recipeURL(at: indexPath)
        navigationController?.pushViewController(webVC, animated: true)
    }
}

private extension RecipeListCollectionViewController {
    func configureCellSize() {
        let width = (view.frame.width - 30) / 2
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else { return }

        layout.itemSize = CGSize(width: width, height: width + 42)
    }
}
