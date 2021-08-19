//
//  SWDataSource.swift
//  SWDataSource
//
//  Created by Роман Есин on 19.08.2021.
//

import Foundation
import UIKit

class SWDataSource<Section: Hashable, Data: Hashable>: UITableViewDiffableDataSource<Section, Data> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
