//
//  ViewController.swift
//  SkyWebTest
//
//  Created by Роман Есин on 19.08.2021.
//

import UIKit

class CategoriesController: SWTableViewController<SWCategory> {

    var searchResults = CategoryItemsViewController(category: nil, products: [])
    var categoryProducts: [Int: [SWProduct]] = [:]

    var loadingIndicator: UIActivityIndicatorView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = nil

        // Search
        searchController = UISearchController(searchResultsController: searchResults)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Product, Ccal..."
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.register(UINib(nibName: "SWCategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")

        dataSource = SWDataSource(tableView: tableView) { tableView, indexPath, category in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? SWCategoryCell else {
                return UITableViewCell()
            }

            cell.loadCategory(category)

            return cell
        }

        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource

        showLoadingIndicator()
        DispatchQueue.main.async {
            self.loadCategories { categories in
                for category in categories {
                    SWApi.getCategoryProducts(category.id) { result in
                        switch result {
                        case .success(let response):
                            let products = response.data
                            self.categoryProducts[category.id] = products
                        case .failure(let error):
                            print(error.localizedDescription)
                        }

                        if self.categoryProducts.count == self.allData.count {
                            DispatchQueue.main.async {
                                self.hideLoadingIndicator()
                            }
                            self.initCategories(categories: categories)
                        }

                        DispatchQueue.main.async {
                            self.refreshControl?.endRefreshing()
                        }
                    }
                }
            }
        }
    }

    func showLoadingIndicator() {
        self.loadingIndicator = UIActivityIndicatorView(style: .large)
        guard let loadingIndicator = loadingIndicator else {
            return
        }

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 50)
        ])

        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        guard let loadingIndicator = loadingIndicator else {
            return
        }

        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()

        self.loadingIndicator = nil
    }

    override func refresh() {
        loadCategories()
    }

    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let category = dataSource.itemIdentifier(for: indexPath),
        let products = self.categoryProducts[category.id] else { return }

        let productsVC = CategoryItemsViewController(category: category, products: products)
        self.navigationController?.pushViewController(productsVC, animated: true)
    }

    // MARK: - Data loading
    private func loadCategories(_ completion: (([SWCategory]) -> Void)? = nil) {
        SWApi.getCategories { [unowned self] result in
            switch result {
            case .success(let response):
                let categories = response.data
                self.allData = categories
                completion?(categories)
            case .failure(let error):
                print(error.localizedDescription)
            }

            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    private func initCategories(categories: [SWCategory]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SWCategory>()
        snapshot.appendSections([0])
        snapshot.appendItems(categories, toSection: 0)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot)
        }
    }
}

extension CategoriesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {

            let filtered = categoryProducts.reduce([SWProduct](), { $0 + $1.value }).filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }.sorted { $0.name < $1.name }

            searchResults.showSearchResults(filtered)
        } else {
            searchResults.showSearchResults([])
        }
    }
}
