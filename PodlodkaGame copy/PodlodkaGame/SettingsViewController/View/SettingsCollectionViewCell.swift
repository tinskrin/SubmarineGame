//
//  SettingsCollectionViewCell.swift
//  PodlodkaGame
//
//  Created by Kris on 01.01.2023.
//

import UIKit

final class SettingsCollectionViewCell: UICollectionViewCell {
	
	private let imageView = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(image: UIImage) {
		imageView.image = image
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}

	private func setupConstraints() {
		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: self.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
}
