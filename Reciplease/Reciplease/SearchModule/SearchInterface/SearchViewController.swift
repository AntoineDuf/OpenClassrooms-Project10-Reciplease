//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 18/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable unused_optional_binding

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButtonView: UIButton!
    @IBOutlet weak var clearButtonView: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel = SearchViewModel(alamofireRequest: AlamofireNetworkRequest())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        displayButtons(enableSearch: false, searchColor: UIColor(named: Asset.greyColorButton.name)!, enableClear: true)
        tableView.removeEmptyCells()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        activityIndicator.stopAnimating()
        if let recipeListVC = segue.destination as? RecipeListCollectionViewController {
            recipeListVC.viewModel = RecipeListViewModel(recipes: viewModel.recipes)
        }
    }
}

extension SearchViewController {
    @IBAction func clearButton(_ sender: Any) {
        viewModel.removeAllIngredients()
        displayButtons(enableSearch: false, searchColor: UIColor(named: Asset.greyColorButton.name)!, enableClear: true)
    }
    @IBAction func searchButton(_ sender: Any) {
        activityIndicator.startAnimating()
        viewModel.getRecipe()
    }
    @IBAction func tappedAddButton(_ sender: Any) {
        addIngredient()
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController {
    func configureViewModel() {
        viewModel.reloadHandler = tableView.reloadData
        viewModel.errorHandler = { [weak self] title in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.alert(title: title)
            }
        }
        viewModel.recipeHandler = { [weak self] in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.performSegue(withIdentifier: StoryboardSegue.Search.searchToCollection.rawValue, sender: nil)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.ingredientsCount
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(IngredientsTableViewCell.self)", for: indexPath)
            as! IngredientsTableViewCell
        let ingredient = viewModel.ingredient(at: indexPath)
        cell.configureCell(ingredient: ingredient)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            viewModel.removeIngredient(at: indexPath)
            if viewModel.ingredientsCount == 0 {
                displayButtons(
                    enableSearch: false,
                    searchColor: UIColor(named: Asset.greyColorButton.name)!,
                    enableClear: true)
            }
        }
    }
}

extension SearchViewController {
    func displayButtons(enableSearch: Bool, searchColor: UIColor, enableClear: Bool) {
        searchButtonView.isEnabled = enableSearch
        searchButtonView.backgroundColor = searchColor
        clearButtonView.isHidden = enableClear
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

    func addIngredient() {
        guard let ingredient = searchBar.text,
            searchBar.text != "",
            let _ = searchBar.text?.rangeOfCharacter(from: CharacterSet.letters) else {
        searchBar.text = ""
        return }
        viewModel.addIngredient(ingredient)
        searchBar.text = ""
        displayButtons(enableSearch: true, searchColor: UIColor(named: Asset.orangeColor.name)!, enableClear: false)
    }
}
