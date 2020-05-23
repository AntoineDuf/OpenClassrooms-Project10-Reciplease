//
//  FavoriteCollectionViewController.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 30/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import CoreData

class FavoriteCollectionViewController: UICollectionViewController {
    var viewModel: FavoriteViewModel!
    var coreDataStack = CoreDataStack(modelName: "Reciplease")

    @IBOutlet weak var favoriteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCellSize()

        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        guard let myRecipe = try? coreDataStack.mainContext.fetch(request) else {
            return
        }
        viewModel = FavoriteViewModel(myRecipes: myRecipe, coreDataStack: CoreDataStack(modelName: "Reciplease"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.reloadRecipes()
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? WebViewController,
            let recipe = viewModel.selectedRecipe {
            webVC.viewModel = WebViewModel(
                recipe: nil,
                favoriteRecipe: recipe,
                openBy: WebViewModel.State.openByFavoriteList
            )
        }
    }

        override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
            if viewModel.recipesCount == 0 {
                favoriteLabel.isHidden = false
                return viewModel.recipesCount
            } else {
                favoriteLabel.isHidden = true
            return viewModel.recipesCount
            }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(FavoriteCollectionViewCell.self)",
            for: indexPath
            ) as? FavoriteCollectionViewCell else { fatalError() }

        let recipe = viewModel.recipe(at: indexPath)
        cell.configureCell(recipe: recipe)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRecipe(at: indexPath)
        performSegue(withIdentifier: StoryboardSegue.Favorite.showWebViewVC.rawValue,
                     sender: nil)
    }
}

extension FavoriteCollectionViewController: UICollectionViewDelegateFlowLayout {
    func configureCellSize() {
        let width = (view.frame.width - 30) / 2
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else { return }

        layout.itemSize = CGSize(width: width, height: width + 42)
    }
}
