//
//  CategoryItemsViewController.swift
//  CategoryItemsViewController
//
//  Created by Роман Есин on 19.08.2021.
//

import UIKit

class CategoryItemsViewController: SWTableViewController<SWProduct> {

    let category: SWCategory?

    var lastItemId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category?.name ?? "Category"

        searchController.searchResultsUpdater = self
        
        navigationItem.rightBarButtonItem = editButtonItem

        // TableView items
        tableView.register(UINib(nibName: "SWProductCell", bundle: nil), forCellReuseIdentifier: "productCell")
        dataSource = SWDataSource(tableView: tableView) { tableView, indexPath, product in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as? SWProductCell else {
                return UITableViewCell()
            }

            cell.loadProduct(product)

            return cell
        }

        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource

        self.initProducts(products: allData)
    }

    override func refresh() {
        self.loadProducts {
            self.initProducts(products: $0)
        }
    }

    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            self.deleteItemAt(indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")

        let config = UISwipeActionsConfiguration(actions: [deleteAction])

        return config
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let product = dataSource.itemIdentifier(for: indexPath) else { return }
        let productVC = ProductOverviewViewController(nibName: "ProductOverviewViewController", bundle: nil)
        productVC.loadProduct(product, category: category)
        self.present(productVC, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let searchText = searchController.searchBar.text, searchText.isEmpty else { return }

        if indexPath.row == dataSource.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            addMoreProducts()
        }
    }

    // MARK: - Data loading
    private func loadProducts(_ completion: @escaping ([SWProduct]) -> Void) {
        SWApi.getCategoryProducts(category?.id ?? 0) { result in
            switch result {
            case .success(let response):
                let products = response.data
                self.allData = products
                completion(products)
            case .failure(let error):
                print(error.localizedDescription)
            }

            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    private func addMoreProducts() {
        loadProducts { [unowned self] products in
            var products = products
            products = products.map {
                var product = $0
                self.lastItemId += 1
                product.id = self.lastItemId
                return product
            }

            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(products, toSection: 0)
            self.dataSource.apply(snapshot)
        }
    }

    func initProducts(products: [SWProduct]) {
        guard products.count > 0 else { return }
        lastItemId = products.last!.id
        var snapshot = NSDiffableDataSourceSnapshot<Int, SWProduct>()
        snapshot.appendSections([0])
        snapshot.appendItems(products, toSection: 0)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    init(category: SWCategory?, products: [SWProduct]) {
        self.category = category
        super.init(style: .insetGrouped)
        self.allData = products
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryItemsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            var filtered: [SWProduct]

            if let ccal = Int(searchText) {
                filtered = allData.filter {
                    ($0.ccal - 30 < ccal) && (ccal < $0.ccal + 30)
                }.sorted { $0.ccal < $1.ccal }

            } else {
                filtered = allData.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }.sorted { $0.name < $1.name }

            }

            showSearchResults(filtered)
        } else {
            showSearchResults(self.allData)
        }
    }
}
