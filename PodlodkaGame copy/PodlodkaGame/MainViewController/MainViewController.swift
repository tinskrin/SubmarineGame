//
//  MainViewController.swift
//  PodlodkaGame
//
//  Created by Kris on 22.08.2022.
//

import UIKit

class MainViewController: UIViewController {

	private let startButton = UIButton()
	private let recordsButton = UIButton()
	private let settingButton = UIButton()
	private let waterImage = UIImageView(frame: UIScreen.main.bounds)
	private let font = UIFont(name: "ComicSansMS", size: 30)

	override func viewDidLoad() {
		super.viewDidLoad()
		createBackgroundImage()
		createRecognizer()
		createButton()
	}
	private func createBackgroundImage(){
		waterImage.image = UIImage(named: "water")
		waterImage.contentMode = UIView.ContentMode.scaleAspectFill
		self.view.insertSubview(waterImage, at: 0)
	}
	private func createButton(){
		let width: CGFloat = 180
		let height: CGFloat = 80
		let space: CGFloat = 20
		let startTitle = "Start game"
		let recordsTitle = "Records"
		let settingTitle = "Settings"
		let atributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont(name: "ComicSansMS", size: 25),
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		let atrStartTitle = NSAttributedString(string: startTitle, attributes: atributes)
		let atrRecordsTitle = NSAttributedString(string: recordsTitle, attributes: atributes)
		let atrSettingTitle = NSAttributedString(string: settingTitle, attributes: atributes)
		startButton.frame = CGRect(x: view.frame.midX - width / 2, y: view.frame.midY - height / 2 - height, width: width, height: height)
		startButton.setColor()
		startButton.setAttributedTitle(atrStartTitle, for: .normal)
		startButton.rounded()
		startButton.dropShadow()
		view.addSubview(startButton)
		recordsButton.frame = CGRect(x: view.frame.midX - width / 2, y: view.frame.midY - height / 2 + space, width: width, height: height)
		recordsButton.setColor()
		recordsButton.setAttributedTitle(atrRecordsTitle, for: .normal)
		recordsButton.rounded()
		recordsButton.dropShadow()
		view.addSubview(recordsButton)
		settingButton.frame = CGRect(x: view.frame.midX - width / 2, y: view.frame.midY - height / 2 + space + space + height, width: width, height: height)
		settingButton.setColor()
		settingButton.setAttributedTitle(atrSettingTitle, for: .normal)
		settingButton.rounded()
		settingButton.dropShadow()
		view.addSubview(settingButton)
	}
	private func createRecognizer(){
		let recognizerStart = UITapGestureRecognizer(target: self, action: #selector(startGameAction))
		startButton.addGestureRecognizer(recognizerStart)
		let recognizerSettings = UITapGestureRecognizer(target: self, action: #selector(settingsAction))
		settingButton.addGestureRecognizer(recognizerSettings)
		let recognizerRecords = UITapGestureRecognizer(target: self, action: #selector(recordsAction))
		recordsButton.addGestureRecognizer(recognizerRecords)
	}
	@objc private func startGameAction(){
		let gameViewController = GameViewController()
		navigationController?.pushViewController(gameViewController, animated: true)
	}
	@objc private func settingsAction(){
		let settingsViewController = SettingsViewController()
		navigationController?.pushViewController(settingsViewController, animated: true)
	}
	@objc private func recordsAction(){
		let recordsViewController = RecordsViewController()
		navigationController?.pushViewController(recordsViewController, animated: true)
	}
}

