//
//  RecordsTableViewCell.swift
//  PodlodkaGame
//
//  Created by Kris on 30.10.2022.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

	private let nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.textAlignment = .center
		nameLabel.font = UIFont(name: "AvenirNextCondensed", size: 15)
		return nameLabel
	}()

	private let gameTimeLabel: UILabel = {
		let gameTimeLabel = UILabel()
		gameTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		gameTimeLabel.textAlignment = .center
		gameTimeLabel.font = UIFont(name: "AvenirNextCondensed", size: 15)
		return gameTimeLabel
	}()

	private let dateLabel: UILabel = {
		let dateLabel = UILabel()
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.textAlignment = .center
		dateLabel.font = UIFont(name: "AvenirNextCondensed", size: 15)
		return dateLabel
	}()

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		return stackView
	}()
	private let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, h:mm a"
		return dateFormatter
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(name: String, gameTime: Double, date: Date) {
		nameLabel.text = name
		gameTimeLabel.text = "\(Int(gameTime))"
		dateLabel.text = "\(dateFormatter.string(from: date))"

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
