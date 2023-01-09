//
//  RecordsViewController.swift
//  PodlodkaGame
//
//  Created by Kris on 23.08.2022.
//

import UIKit

class RecordsViewController: UIViewController {

	private let waterImage = UIImageView(frame: UIScreen.main.bounds)
	var array = GameResult.shared.allGameResult

	let recordsTableView: UITableView = {
		let recordsTableView = UITableView()
		recordsTableView.translatesAutoresizingMaskIntoConstraints = false
		return recordsTableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		createBackgroundImage()
		setupViews()
		setupContraints()
		array.sort{ $0.gameTime > $1.gameTime }
		recordsTableView.delegate = self
		recordsTableView.dataSource = self
		recordsTableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: "RecordsTableViewCell")
		recordsTableView.backgroundColor = .clear
    }

	private func createBackgroundImage(){
		waterImage.image = UIImage(named: "water")
		waterImage.contentMode = UIView.ContentMode.scaleAspectFill
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = waterImage.frame
		waterImage.addSubview(blurEffectView)
		self.view.insertSubview(waterImage, at: 0)
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
				recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

			]
		)
	}
}
extension RecordsViewController: UITableViewDelegate {

}

extension RecordsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return TitleLabelView()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsTableViewCell", for: indexPath) as? RecordsTableViewCell else { return UITableViewCell() }
		cell.backgroundColor = .clear
		cell.selectionStyle = .none
		cell.configure(name: array[indexPath.row].name, gameTime: array[indexPath.row].gameTime, date: array[indexPath.row].gameDate)
		return cell
	}


}
