//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Antoine Dufayet on 18/03/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var searchButtonView: UIButton!
    @IBOutlet weak var clearButtonView: UIButton!

    var viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        displayButtons(enableSearch: false, searchColor: UIColor(named: "GreyColorButton")!, enableClear: true)
        tableView.removeEmptyCells()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipeListVC = segue.destination as? RecipeListCollectionViewController {
            recipeListVC.viewModel = RecipeListViewModel(recipes: viewModel.recipes)
        }
    }
}

extension SearchViewController {
    @IBAction func addButton(_ sender: Any) {
        guard let ingredient = ingredientTextField.text,
            ingredientTextField.text != ""
            else { return }
        viewModel.addIngredient(ingredient)
        ingredientTextField.text = ""
        displayButtons(enableSearch: true, searchColor: UIColor(named: "OrangeColor")!, enableClear: false)
    }
    @IBAction func clearButton(_ sender: Any) {
        viewModel.removeAllIngredients()
        displayButtons(enableSearch: false, searchColor: UIColor(named: "GreyColorButton")!, enableClear: true)
    }
    @IBAction func searchButton(_ sender: Any) {
        viewModel.getRecipe()
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
                me.performSegue(withIdentifier: "searchToCollection", sender: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientsTableViewCell
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
                displayButtons(enableSearch: false, searchColor: UIColor(named: "GreyColorButton")!, enableClear: true)
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
