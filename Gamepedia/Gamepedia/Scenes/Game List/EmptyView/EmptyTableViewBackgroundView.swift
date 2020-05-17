//
//  EmptyTableViewBackgroundView.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 17.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

class EmptyTableViewBackgroundView: UIView {

    private enum Constants {
        static let labelTopSpace: CGFloat = 38.0
        static let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    }

    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray229
        titleLabel.font = Constants.titleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.labelTopSpace).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
