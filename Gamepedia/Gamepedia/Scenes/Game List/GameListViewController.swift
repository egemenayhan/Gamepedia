//
//  GameListViewController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

class GameListViewController: BaseViewController {

    enum Constants {
        static let rowHeight: CGFloat = 136.0
    }

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    let viewModel = GameListViewModel()
    private var presentation = GameListViewControllerPresentation()

    // TODO: implementation
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "GAMES"

        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = Constants.rowHeight
        tableView.register(
            GameTableViewCell.nib,
            forCellReuseIdentifier: GameTableViewCell.reuseIdentifier
        )

        viewModel.stateChangeHandler = handleStateChange(change:)
        viewModel.reloadGames()
    }

    private func handleStateChange(change: GameListState.Change) {
        // TODO: handle changes
        switch change {
        case .gamesFetched:
            presentation.update(with: viewModel.state)
            tableView.reloadData()
        default:
            break
        }
    }

}

extension GameListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentation.presentations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.reuseIdentifier,
            for: indexPath) as? GameTableViewCell else {
                return UITableViewCell()
        }

        cell.presentation = presentation.presentations[indexPath.row]

        return cell
    }

}
