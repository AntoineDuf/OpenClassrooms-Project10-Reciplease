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
    @IBOutlet weak var noRecipesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCellSize()
        if viewModel.recipesCount > 0 {
            noRecipesLabel.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? WebViewController,
            let recipe = viewModel.selectedRecipe {
            webVC.viewModel = WebViewModel(
                recipe: recipe,
                favoriteRecipe: nil,
                openBy: WebViewModel.State.openByRecipeList
            )
        }
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
            withReuseIdentifier: L10n.recipeCellName,
            for: indexPath
            ) as? RecipeCollectionViewCell else { fatalError() }

        let recipe = viewModel.recipe(at: indexPath)
        cell.configureCell(recipe: recipe)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRecipe(at: indexPath)
        performSegue(withIdentifier: StoryboardSegue.Search.showWebViewVC.rawValue, sender: nil)
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
