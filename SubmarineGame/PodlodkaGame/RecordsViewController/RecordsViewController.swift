//
//  RecordsViewController.swift
//  PodlodkaGame
//
//  Created by Kris on 23.08.2022.
//

import UIKit

class RecordsViewController: UIViewController {

	private let waterImage: UIImageView = {
		let waterImage = UIImageView()
		waterImage.image = UIImage(named: "water")
		waterImage.contentMode = UIView.ContentMode.scaleAspectFill
		waterImage.translatesAutoresizingMaskIntoConstraints = false
		return waterImage
	}()
	private let blurEffectView: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.translatesAutoresizingMaskIntoConstraints = false
		return blurEffectView
	}()

	var gamesScore = GameResult.shared.allGameResult

	let recordsTableView: UITableView = {
		let recordsTableView = UITableView()
		recordsTableView.translatesAutoresizingMaskIntoConstraints = false
		return recordsTableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		createBlur(image: waterImage)
		setupViews()
		setupContraints()
		recordsTableView.dataSource = self
		recordsTableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: "RecordsTableViewCell")
		recordsTableView.backgroundColor = .clear
    }

	private func createBlur(image: UIImageView){
		image.addSubview(blurEffectView)
		self.view.insertSubview(image, at: 0)
	}
	private func setupViews(){
		view.addSubview(recordsTableView)
	}
	private func setupContraints(){
		NSLayoutConstraint.activate(
			[
				recordsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				recordsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				recordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

				waterImage.topAnchor.constraint(equalTo: view.topAnchor),
				waterImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				waterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				waterImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

				blurEffectView.topAnchor.constraint(equalTo: waterImage.topAnchor),
				blurEffectView.bottomAnchor.constraint(equalTo: waterImage.bottomAnchor),
				blurEffectView.leadingAnchor.constraint(equalTo: waterImage.leadingAnchor),
				blurEffectView.trailingAnchor.constraint(equalTo: waterImage.trailingAnchor)

			]
		)
	}
}

extension RecordsViewController: UITableViewDataSource {

	private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return TitleLabelView()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		gamesScore.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsTableViewCell", for: indexPath) as? RecordsTableViewCell else { return UITableViewCell() }
		cell.backgroundColor = .clear
		cell.selectionStyle = .none
		cell.configure(name: gamesScore[indexPath.row].name, gameTime: gamesScore[indexPath.row].gameTime, date: gamesScore[indexPath.row].gameDate)
		return cell
	}
}
