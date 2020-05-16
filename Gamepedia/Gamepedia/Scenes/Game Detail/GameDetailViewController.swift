//
//  GameDetailViewController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 16.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit
import AlamofireImage

// MARK: - GameDetailViewController

class GameDetailViewController: BaseViewController {

    private enum Constants {
        static let gradientAlpha: CGFloat = 0.8
        static let gradientColors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor]
        static let barButtonFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: 90.0, height: 22.0)
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionContainerStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var redditContainerStackView: UIStackView!
    @IBOutlet private weak var redditButton: UIButton!
    @IBOutlet private weak var websiteContainerStackView: UIStackView!
    @IBOutlet private weak var websiteButton: UIButton!
    @IBOutlet private weak var gradientImageView: UIImageView!

    var viewModel: GameDetailViewModel!
    var presentation: GameDetailViewControllerPresentation!
    private var favoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        configureUI()
        updateUI()

        viewModel.fetchGameDetails()
    }

    private func configureViewModel() {
        viewModel.addChangeHandler { [weak self] (change) in
            switch change {
            case .loading:
                break
            case .loaded:
                break
            case .gameDetailsFetched:
                self?.updateUI()
            default:
                break
            }
        }
    }

    private func configureUI() {
        gradientImageView.image = UIImage.gradientImageWithBounds(
            bounds: imageView.bounds,
            colors: Constants.gradientColors
        )
        gradientImageView.alpha = Constants.gradientAlpha

        favoriteButton = UIButton(frame: Constants.barButtonFrame)
        favoriteButton.setTitleColor(.systemBlue, for: .normal)
        favoriteButton.titleLabel?.font = UIFont(name: "System", size: 17.0)
        favoriteButton.contentHorizontalAlignment = .trailing
        favoriteButton.addTarget(self, action: #selector(favoriteTapeed(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButton
    }

    private func updateUI() {
        favoriteButton.setTitle(
            presentation.isFavorite ? "Unfavorite" : "Favorite",
            for: .normal
        )

        if let imageURL = URL(string: presentation.gameImagePath ?? "") {
            imageView.af.setImage(withURL: imageURL)
        }

        nameLabel.text = presentation.name
        descriptionContainerStackView.isHidden = presentation.description?.isEmpty ?? true
        descriptionLabel.text = presentation.description
        redditContainerStackView.isHidden = presentation.redditPath?.isEmpty ?? true
        websiteContainerStackView.isHidden = presentation.redditPath?.isEmpty ?? true
    }

    // MARK: - Actions

    @IBAction private func visitRedditTapped(_ sender: Any) {
        // TODO: action
    }

    @IBAction private func visitWebsiteTapped(_ sender: Any) {
        // TODO: action
    }

    @objc private func favoriteTapeed(_ sender: Any) {
        // TODO: action
        presentation.isFavorite.toggle()
        updateUI()
    }

}
