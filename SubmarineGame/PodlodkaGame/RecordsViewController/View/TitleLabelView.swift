//
//  TitleLabelView.swift
//  PodlodkaGame
//
//  Created by Kris on 30.10.2022.
//

import Foundation
import UIKit

class TitleLabelView: UIView {

	private let nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.text = "Name"
		nameLabel.textAlignment = .center
		nameLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
		return nameLabel
	}()

	private let gameTimeLabel: UILabel = {
		let GameTimeLabel = UILabel()
		GameTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		GameTimeLabel.text = "Game time"
		GameTimeLabel.textAlignment = .center
		GameTimeLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
		return GameTimeLabel
	}()

	private let dateLabel: UILabel = {
		let DateLabel = UILabel()
		DateLabel.translatesAutoresizingMaskIntoConstraints = false
		DateLabel.text = "Date"
		DateLabel.textAlignment = .center
		DateLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
		return DateLabel
	}()

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		return stackView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews(){
		stackView.addArrangedSubview(nameLabel)
		stackView.addArrangedSubview(gameTimeLabel)
		stackView.addArrangedSubview((dateLabel))
		addSubview(stackView)
	}

	private func setupConstraints(){
		NSLayoutConstraint.activate(
			[
				stackView.topAnchor.constraint(equalTo: topAnchor),
				stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
				stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
				stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)

			]
		)
	}
	
}
