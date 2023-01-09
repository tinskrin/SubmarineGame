//
//  SettingsViewController.swift
//  PodlodkaGame
//
//  Created by Kris on 23.08.2022.
//

import UIKit

private struct Constants {
	static let fishSize = CGSize(width: 90, height: 90)
	static let space: CGFloat = 20
}

final class SettingsViewController: UIViewController {

// MARK: - Properties

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.backgroundColor = .blue.withAlphaComponent(0.2)
		scrollView.layer.cornerRadius = 15
		return scrollView
	}()
	private let waterImage = UIImageView(frame: UIScreen.main.bounds)
	private let nicknameLabel: UILabel = {
		let nicknameLabel = UILabel()
		nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
		nicknameLabel.text = "Nickname: "
		nicknameLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return nicknameLabel
	}()
	private let nicknameTextFiled: UITextField = {
		let textFiled = UITextField()
		textFiled.backgroundColor = .blue.withAlphaComponent(0.05)
		textFiled.translatesAutoresizingMaskIntoConstraints = false
		return textFiled
	}()
	private let settingsLabel: UILabel = {
		let settingsLabel = UILabel()
		settingsLabel.translatesAutoresizingMaskIntoConstraints = false
		settingsLabel.text = "Game settings"
		settingsLabel.font = UIFont(name: "AvenirNextCondensed-Bold" , size: 30)
		return settingsLabel
	}()
	private let speedLabel: UILabel = {
		let speedLabel = UILabel()
		speedLabel.translatesAutoresizingMaskIntoConstraints = false
		speedLabel.text = "Game speed: "
		speedLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return speedLabel
	}()
	private let controlLabel: UILabel = {
		let controlLabel = UILabel()
		controlLabel.translatesAutoresizingMaskIntoConstraints = false
		controlLabel.text = "Game control: "
		controlLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return controlLabel
	}()
	private let gameTypeControl: UISegmentedControl = {
		let chooseControl = UISegmentedControl(items: GameType.allTypes)
		chooseControl.translatesAutoresizingMaskIntoConstraints = false
		chooseControl.backgroundColor = .clear
		chooseControl.tintColor = .blue
		return chooseControl
	}()

	private lazy var speedSlider: UISlider = {
		let speedSlider = UISlider()
		speedSlider.isContinuous = false
		speedSlider.addTarget(self, action: #selector(sliderChangeAction), for: .valueChanged)
		speedSlider.minimumValue = 1
		speedSlider.maximumValue = 3
		speedSlider.value = speedSlider.minimumValue
		speedSlider.minimumTrackTintColor = .black
		speedSlider.translatesAutoresizingMaskIntoConstraints = false
		return speedSlider
	}()
	private let speedValueLabel: UILabel = {
		let speedValueLabel = UILabel()
		speedValueLabel.translatesAutoresizingMaskIntoConstraints = false
		return speedValueLabel
	}()
	private let chooseSubmarinesLabel: UILabel = {
		let submarinesLabel = UILabel()
		submarinesLabel.translatesAutoresizingMaskIntoConstraints = false
		submarinesLabel.text = "Choose your favourite submarine"
		submarinesLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return submarinesLabel
	}()
	private let chooseFishesLabel: UILabel = {
		let fishLabel = UILabel()
		fishLabel.translatesAutoresizingMaskIntoConstraints = false
		fishLabel.text = "Choose your favourite obstacle"
		fishLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return fishLabel
	}()
	private let collectionViewSubmarine: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .horizontal
		viewLayout.itemSize = Constants.fishSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .clear
		return collectionView
	}()

	private let saveNicknameButton: UIButton = {
		let saveNicknameButton = UIButton()
		saveNicknameButton.translatesAutoresizingMaskIntoConstraints = false
		saveNicknameButton.backgroundColor = .clear
		saveNicknameButton.setTitle("Save", for: .normal)
		saveNicknameButton.layer.cornerRadius = 10
		saveNicknameButton.setTitleColor(.black, for: .normal)
		saveNicknameButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
		return saveNicknameButton
	}()

	private let collectionViewFish: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .horizontal
		viewLayout.itemSize = Constants.fishSize
		let collectionViewFish = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		collectionViewFish.showsHorizontalScrollIndicator = false
		collectionViewFish.translatesAutoresizingMaskIntoConstraints = false
		collectionViewFish.backgroundColor = .clear
		return collectionViewFish
	}()

	private var submarineImages: [UIImage] = []
	private var fishImages: [UIImage] = []

	private let cellSubmarineIdentifier = "SubmarineCell"
	private let cellFishIdentifier = "FishCell"

	private let settings = GameSettings.shared

// MARK: - Lifecycle funcs

    override func viewDidLoad() {
        super.viewDidLoad()
		setBackgroundImage()
		addSubviews()
		setupViews()
		setUpConstraints()
		setupSubmarines()
		setUpFishes()
		setupRecognizer()
		setupNickname()
		setupCurrentSpeed()
		setupGameTypeControl()
    }

	private func setBackgroundImage(){
		waterImage.image = UIImage(named: "water")
		waterImage.contentMode = UIView.ContentMode.scaleAspectFill
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = waterImage.frame
		waterImage.addSubview(blurEffectView)
		self.view.insertSubview(waterImage, at: 0)
	}

	private func addSubviews() {
		view.addSubview(scrollView)
		scrollView.addSubview(nicknameLabel)
		scrollView.addSubview(settingsLabel)
		scrollView.addSubview(nicknameTextFiled)
		scrollView.addSubview(speedLabel)
		scrollView.addSubview(speedSlider)
		scrollView.addSubview(speedValueLabel)
		scrollView.addSubview(chooseSubmarinesLabel)
		scrollView.addSubview(collectionViewSubmarine)
		scrollView.addSubview(chooseFishesLabel)
		scrollView.addSubview(collectionViewFish)
		scrollView.addSubview(saveNicknameButton)
		scrollView.addSubview(controlLabel)
		scrollView.addSubview(gameTypeControl)
	}

	private func setupRecognizer() {
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(saveNicknameButtonAction))
		saveNicknameButton.addGestureRecognizer(recognizer)
	}

	private func setupGameTypeControl() {
		gameTypeControl.addTarget(self, action: #selector(setupGameControl(_:)), for: .valueChanged)
		gameTypeControl.selectedSegmentIndex = settings.currentControl.rawValue
	}

	@objc private func setupGameControl(_ sender: UISegmentedControl) {
		if let gameType = GameType(rawValue: sender.selectedSegmentIndex) {
			settings.changeGameType(for: gameType)
		}
	}

	private func setUpConstraints(){
		let widthMargin: CGFloat = 100
		let width = view.frame.width - widthMargin * 2 - Constants.space * 2
		NSLayoutConstraint.activate(
			[
				scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthMargin),
				scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthMargin),
				scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
				scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),

				settingsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.space),
				settingsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

				nicknameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.space),
				nicknameLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: Constants.space),

				saveNicknameButton.leadingAnchor.constraint(equalTo: nicknameTextFiled.trailingAnchor, constant: Constants.space),
				saveNicknameButton.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),

				nicknameTextFiled.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: Constants.space),
				nicknameTextFiled.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
				nicknameTextFiled.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
				nicknameTextFiled.widthAnchor.constraint(equalToConstant: widthMargin),

				speedLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
				speedLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: Constants.space),

				speedSlider.leadingAnchor.constraint(equalTo: speedLabel.trailingAnchor, constant: Constants.space),
				speedSlider.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
				speedSlider.widthAnchor.constraint(equalToConstant: widthMargin),

				speedValueLabel.leadingAnchor.constraint(equalTo: speedSlider.trailingAnchor, constant: Constants.space),
				speedValueLabel.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
				speedValueLabel.widthAnchor.constraint(equalToConstant: widthMargin),

				controlLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: Constants.space),
				controlLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),

				gameTypeControl.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: Constants.space),
				gameTypeControl.leadingAnchor.constraint(equalTo: controlLabel.trailingAnchor, constant: Constants.space),


				chooseSubmarinesLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
				chooseSubmarinesLabel.topAnchor.constraint(equalTo: controlLabel.bottomAnchor, constant: Constants.space),
				chooseSubmarinesLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.space),


				collectionViewSubmarine.topAnchor.constraint(equalTo: chooseSubmarinesLabel.bottomAnchor, constant: Constants.space),
				collectionViewSubmarine.leadingAnchor.constraint(equalTo: chooseSubmarinesLabel.leadingAnchor),
				collectionViewSubmarine.heightAnchor.constraint(equalToConstant: Constants.fishSize.width),
				collectionViewSubmarine.widthAnchor.constraint(equalToConstant: width),

				chooseFishesLabel.topAnchor.constraint(equalTo: collectionViewSubmarine.bottomAnchor, constant: Constants.space),
				chooseFishesLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
				chooseFishesLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.space),

				collectionViewFish.topAnchor.constraint(equalTo: chooseFishesLabel.bottomAnchor, constant: Constants.space),
				collectionViewFish.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.space),
				collectionViewFish.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.space),
				collectionViewFish.heightAnchor.constraint(equalToConstant: Constants.fishSize.width),
				collectionViewFish.widthAnchor.constraint(equalToConstant: width)
			]
		)
	}
	@objc private func sliderChangeAction(speedSlider: UISlider) {
		speedSlider.setValue(speedSlider.value.rounded(), animated: true)
		speedValueLabel.text = speedSlider.value.description
		settings.changeCurrentGameSpeed(gameSpeed: Double(speedSlider.value))
	}

	private func setupViews() {
		collectionViewSubmarine.dataSource = self
		collectionViewSubmarine.delegate = self
		collectionViewSubmarine.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: cellSubmarineIdentifier)
		collectionViewFish.dataSource = self
		collectionViewFish.delegate = self
		collectionViewFish.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: cellFishIdentifier)
	}
	private func setupSubmarines() {
		for sumbarine in settings.allSubmarines {
			if let submarineImage = UIImage(named: sumbarine) {
				submarineImages.append(submarineImage)
			}
		}
	}

	private func setUpFishes() {
		for fish in settings.allFish {
			if let fishImage = UIImage(named: fish) {
				fishImages.append(fishImage)
			}
		}
	}
	@objc private func saveNicknameButtonAction() {
		if let nickname = nicknameTextFiled.text {
			settings.changeNickname(nickname: nickname)
		}
	}
	private func setupNickname() {
		nicknameTextFiled.text = settings.nickname

	}
	private func setupCurrentSpeed() {
		speedValueLabel.text = "\(settings.currentGameSpeed)"
		speedSlider.setValue(Float(settings.currentGameSpeed), animated: true)
	}
}

// MARK: - UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == collectionViewFish {
			return fishImages.count
		}
		return submarineImages.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == collectionViewFish {
			let cellFish = collectionViewFish.dequeueReusableCell(withReuseIdentifier: cellFishIdentifier, for: indexPath) as? SettingsCollectionViewCell
			cellFish?.configure(image: fishImages[indexPath.row])
			return cellFish!
		}
		let cellsubmarine = collectionView.dequeueReusableCell(withReuseIdentifier: cellSubmarineIdentifier, for: indexPath) as? SettingsCollectionViewCell
		cellsubmarine?.configure(image: submarineImages[indexPath.row])
		return cellsubmarine!
	}
}

// MARK: - UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == collectionViewFish {
			settings.changeCurrentFish(fishIndex: indexPath.row)
		} else if self.collectionViewSubmarine == collectionView {
			settings.changeCurrentSubmarine(submarineIndex: indexPath.row)
		}
	}
}
