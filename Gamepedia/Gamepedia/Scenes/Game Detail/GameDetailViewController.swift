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
        static let loadingCornerRadius: CGFloat = 10.0
        static let descriptionNumberOfLine = 4
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionContainerStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var expandTextButton: UIButton!
    @IBOutlet private weak var redditContainerStackView: UIStackView!
    @IBOutlet private weak var redditButton: UIButton!
    @IBOutlet private weak var websiteContainerStackView: UIStackView!
    @IBOutlet private weak var websiteButton: UIButton!
    @IBOutlet private weak var gradientImageView: UIImageView!
    @IBOutlet private weak var loadingView: UIView!

    private var router = GameDetailRouter()
    var viewModel: GameDetailViewModel!
    var presentation: GameDetailViewControllerPresentation!
    private var favoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        configureViewModel()
        configureUI()
        updateUI()

        viewModel.fetchGameDetails()
    }

    private func configureViewModel() {
        viewModel.addChangeHandler { [weak self] (change) in
            guard let strongSelf = self else { return }
            switch change {
            case .loading:
                strongSelf.loadingView.isHidden = false
            case .loaded:
                strongSelf.loadingView.isHidden = true
            case .gameDetailsFetched:
                strongSelf.presentation.update(with: strongSelf.viewModel.state)
                strongSelf.updateUI()
            case .favoriteStateUpdated:
                strongSelf.presentation.update(with: strongSelf.viewModel.state)
                strongSelf.updateFavoriteState()
            case .showError(_):
                // TODO: handle error
                break
            }
        }
    }

    private func configureUI() {
        loadingView.isHidden = true
        loadingView.layer.cornerRadius = Constants.loadingCornerRadius
        loadingView.layer.masksToBounds = true

        gradientImageView.image = UIImage.gradientImageWithBounds(
            bounds: imageView.bounds,
            colors: Constants.gradientColors
        )
        gradientImageView.alpha = Constants.gradientAlpha

        favoriteButton = UIButton(frame: Constants.barButtonFrame)
        favoriteButton.setTitleColor(.systemBlue, for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        favoriteButton.contentHorizontalAlignment = .trailing
        favoriteButton.addTarget(self, action: #selector(favoriteTapeed(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButton

        descriptionLabel.numberOfLines = Constants.descriptionNumberOfLine

        expandTextButton.setTitle("Read More", for: .normal)
        expandTextButton.setTitle("Read Less", for: .selected)
    }

    private func updateUI() {
        updateFavoriteState()

        if let imageURL = URL(string: presentation.gameImagePath ?? "") {
            imageView.af.setImage(withURL: imageURL)
        }

        nameLabel.text = presentation.name

        // TODO: there is a bug for last line. looks compressed
        if let description = presentation.description {
            let mutableAttributedString = NSMutableAttributedString(attributedString: description)
            mutableAttributedString.addAttributes(
                [.font: UIFont.systemFont(ofSize: 10.0)],
                range: NSMakeRange(0, mutableAttributedString.length)
            )
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.lineBreakMode = .byTruncatingTail
            mutableAttributedString.addAttribute(
                .paragraphStyle,
                value:paragraphStyle,
                range:NSMakeRange(0, mutableAttributedString.length)
            )
            descriptionContainerStackView.isHidden = false
            descriptionLabel.attributedText = mutableAttributedString
        } else {
            descriptionContainerStackView.isHidden = true
        }

        redditContainerStackView.isHidden = presentation.redditPath?.isEmpty ?? true
        websiteContainerStackView.isHidden = presentation.redditPath?.isEmpty ?? true
    }

    private func updateFavoriteState() {
        favoriteButton.setTitle(
            presentation.isFavorite ? "Unfavorite" : "Favorite",
            for: .normal
        )
        favoriteButton.isHidden = viewModel.state.game == nil
    }

    // MARK: - Actions

    @IBAction private func visitRedditTapped(_ sender: Any) {
        guard let path = presentation.redditPath else { return }
        router.routeToPath(path)
    }

    @IBAction private func visitWebsiteTapped(_ sender: Any) {
        guard let path = presentation.websitePath else { return }
        router.routeToPath(path)
    }

    @objc private func favoriteTapeed(_ sender: Any) {
        viewModel.toggleFavoriteState()
    }

    @IBAction private func expandTextTapped(_ sender: Any) {
        expandTextButton.isSelected.toggle()
        descriptionLabel.numberOfLines = expandTextButton.isSelected ? 0 : Constants.descriptionNumberOfLine
    }

}
