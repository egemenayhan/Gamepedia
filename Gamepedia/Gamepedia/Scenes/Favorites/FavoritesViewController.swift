//
//  FavoritesViewController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

// MARK: - FavoritesRouter

struct FavoritesRouter: GameDetailRoutable {}

// MARK: - FavoritesViewController

class FavoritesViewController: BaseViewController {

    private enum Constants {
        static let rowHeight: CGFloat = 136.0
    }

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureTableView()

        updateNavigationTitle()

        tableView.reloadData()
    }

    private var viewModel = FavoritesViewModel()
    private var router = FavoritesRouter()
    private var presentation = FavoritesViewControllerPresentation()

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constants.rowHeight
        tableView.register(
            GameTableViewCell.nib,
            forCellReuseIdentifier: GameTableViewCell.reuseIdentifier
        )
    }

    private func configureViewModel() {
        viewModel.addChangeHandler { [weak self] (change) in
            guard let strongSelf = self else { return }
            switch change {
            case .favoritesUpdated:
                strongSelf.updateNavigationTitle()
                strongSelf.presentation.update(with: strongSelf.viewModel.state)
                strongSelf.tableView.reloadData()
            }
        }
        presentation.update(with: viewModel.state)
    }

    private func updateNavigationTitle() {
        navigationItem.title = "Favorites (\(viewModel.state.favorites.count))"
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.favorites.count
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

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = viewModel.state.favorites[indexPath.row]
        router.routeToGameDetail(from: self, game: game)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Unfavorite") { [weak self] (action, indexPath) in
            let alertController = UIAlertController(
                title: "Warning!",
                message:"This game will be removed from your favorite list. Are you sure?",
                preferredStyle: .alert
            )
            alertController.addAction(
                UIAlertAction(title: "Yes", style: .destructive) { (action) in
                    self?.viewModel.unfavoriteGame(at: indexPath.row)
                }
            )
            alertController.addAction(UIAlertAction(title: "No", style: .cancel))

            self?.present(alertController, animated: true, completion: nil)
        }

        return [deleteAction]
    }

}
