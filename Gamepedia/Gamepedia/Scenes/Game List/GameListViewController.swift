//
//  GameListViewController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

// MARK: - GameListRouter

struct GameListRouter: GameDetailRoutable {}

// MARK: - GameListViewController

class GameListViewController: BaseViewController {

    private enum Constants {
        static let rowHeight: CGFloat = 136.0
        static let tableFooterHeight: CGFloat = 30.0
        static let nextPageFetchThreshold = 2
    }

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    let viewModel = GameListViewModel()
    private var presentation = GameListViewControllerPresentation()
    private var activityIndicatorView = UIActivityIndicatorView()
    private var refreshControl = UIRefreshControl()
    private let router = GameListRouter()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Games"

        configureTableView()

        searchBar.delegate = self

        configureViewModel()
        preloadContent()
        viewModel.reloadGames()
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func preloadContent() {
        presentation.update(with: viewModel.state)
        tableView.reloadData()
    }

    private func configureTableView() {
        activityIndicatorView.startAnimating()
        let footerView = UIView(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: tableView.bounds.width,
                height: Constants.tableFooterHeight
            )
        )
        footerView.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        tableView.tableFooterView = footerView

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadUI), for: .valueChanged)
        tableView.addSubview(refreshControl)

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
            case .nextPageFetched(let games):
                strongSelf.presentation.updateWithNextPage(games)
                strongSelf.tableView.reloadData()
            case .gamesReloaded:
                strongSelf.refreshControl.endRefreshing()
                strongSelf.presentation.update(with: strongSelf.viewModel.state)
                strongSelf.tableView.reloadData()
            case .loading:
                strongSelf.activityIndicatorView.startAnimating()
            case .loaded:
                strongSelf.activityIndicatorView.stopAnimating()
                strongSelf.refreshControl.endRefreshing()
            case .dataSourceUpdated:
                strongSelf.presentation.update(with: strongSelf.viewModel.state)
                strongSelf.tableView.reloadData()
                strongSelf.scrollToTop()
            case .gameSetAsReaded(let index):
                strongSelf.presentation.gameSetAsReaded(at: index)
                strongSelf.tableView.reloadRows(
                    at: [IndexPath(row: index, section: 0)],
                    with: .automatic
                )
            case .showError(let error):
                strongSelf.scrollToTop()
                let alertController = UIAlertController(
                    title: "Error!",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                strongSelf.present(alertController, animated: true, completion: nil)
            }
        }
    }

    private func scrollToTop() {
        if viewModel.state.sourceArray.count > 0 {
            tableView.scrollToRow(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: true
            )
        }
    }

    @objc private func reloadUI() {
        viewModel.reloadGames()
    }

    private func showEmptyViewIfNeeded() {
        if viewModel.state.isSearchActive, (searchBar.text?.count ?? 0) < Global.minimumCharacterCountForSearch {
            let emptyView = EmptyTableViewBackgroundView(frame: tableView.bounds)
            emptyView.titleLabel.text = "No game has been searched."
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
    }

}

// MARK: - UITableViewDataSource

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

// MARK: - UITableViewDelegate

extension GameListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == viewModel.state.sourceArray.count - Constants.nextPageFetchThreshold {
            viewModel.fetchNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = viewModel.state.sourceArray[indexPath.row]
        router.routeToGameDetail(from: self, game: game)
    }

}

// MARK: - UISearchBarDelegate

extension GameListViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.enableSearch(true)
        showEmptyViewIfNeeded()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {
            viewModel.enableSearch(false)
        }
        showEmptyViewIfNeeded()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= Global.minimumCharacterCountForSearch {
            viewModel.search(text: searchText)
        }
        showEmptyViewIfNeeded()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

}
