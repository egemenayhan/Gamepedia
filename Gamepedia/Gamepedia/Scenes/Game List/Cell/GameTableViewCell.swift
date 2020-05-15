//
//  GameTableViewCell.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 15.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit
import AlamofireImage

struct GameTableViewCellPresentation {

    let gameImagePath: String?
    let name: String?
    let metacriticScore: Int?
    let genres: [Genre]?
    var isReaded: Bool = false

}

// MARK: - GameTableViewCell

class GameTableViewCell: UITableViewCell, NibLoadable {

    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var metacriticStackView: UIStackView!
    @IBOutlet private weak var metacriticScoreLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!

    var presentation: GameTableViewCellPresentation? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        guard let presentation = presentation else { return }

        if let imageURL = URL(string: presentation.gameImagePath ?? "") {
            gameImageView?.af.setImage(withURL: imageURL)
        }

        nameLabel.text = presentation.name

        if let metacriticScore = presentation.metacriticScore {
            metacriticScoreLabel.text = "\(metacriticScore)"
            metacriticStackView.isHidden = false
        } else {
            metacriticStackView.isHidden = true
        }

        backgroundColor = presentation.isReaded ? .gray224 : .white

        // TODO: add genres
        // TODO: handle readed case
    }

}

