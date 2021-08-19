//
//  SWTableViewController.swift
//  SWTableViewController
//
//  Created by Роман Есин on 19.08.2021.
//

import UIKit

class SWTableViewController<Data: Hashable>: UITableViewController {
    var dataSource: SWDataSource<Int, Data>!
    var allData: [Data] = []

    var searchController: UISearchController!

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = UITableView.automaticDimension

        refreshControl = .init()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        // Search
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Product, Ccal..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    @objc func refresh() {}

    func removeAll() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)
    }

    func deleteItemAt(_ indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
    }

    func showSearchResults(_ data: [Data]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Data>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}
