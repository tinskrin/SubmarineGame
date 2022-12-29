//
//  SettingsViewController.swift
//  PodlodkaGame
//
//  Created by Kris on 23.08.2022.
//

import UIKit

class SettingsViewController: UIViewController {

// MARK: - Properties

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsHorizontalScrollIndicator = false
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
	private let textFiled: UITextField = {
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
	private let submarinesLabel: UILabel = {
		let submarinesLabel = UILabel()
		submarinesLabel.translatesAutoresizingMaskIntoConstraints = false
		submarinesLabel.text = "Choose your favourite submarine"
		submarinesLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return submarinesLabel
	}()
	private let fishLabel: UILabel = {
		let fishLabel = UILabel()
		fishLabel.translatesAutoresizingMaskIntoConstraints = false
		fishLabel.text = "Choose your favourite obstacle"
		fishLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold" , size: 20)
		return fishLabel
	}()
	private let collectionView: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .horizontal
		viewLayout.itemSize = CGSize(width: 90, height: 90)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .white
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
		viewLayout.itemSize = CGSize(width: 90, height: 90)
		let collectionViewFish = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		collectionViewFish.translatesAutoresizingMaskIntoConstraints = false
		collectionViewFish.backgroundColor = .white
		return collectionViewFish
	}()

	private var submarineImageViewArray: [UIImageView] = []
	private var fishImageViewArray: [UIImageView] = []

	private let cellIdentifier = String(describing: UICollectionViewCell.self)
	private let cellFishIdentifier = String(describing: UICollectionViewCell.self) + "aekufgq,wauegf"

	private let settings = GameSettings.shared

// MARK: - Lifecycle funcs

    override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.backgroundColor = .clear
		collectionViewFish.backgroundColor = .clear
		scrollView.contentSize = CGSize(width: 400, height: 1000)
		createBackgroundImage()
		addSubviews()
		setUpConstraints()
		setupSubmarines()
		setUpFishes()
		setupRecognizer()
		setupNickname()
		setupCurrentSpeed()

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
	private func addSubviews(){
		view.addSubview(scrollView)
		scrollView.addSubview(nicknameLabel)
		scrollView.addSubview(settingsLabel)
		scrollView.addSubview(textFiled)
		scrollView.addSubview(speedLabel)
		scrollView.addSubview(speedSlider)
		scrollView.addSubview(speedValueLabel)
		scrollView.addSubview(submarinesLabel)
		scrollView.addSubview(collectionView)
		scrollView.addSubview(fishLabel)
		scrollView.addSubview(collectionViewFish)
		scrollView.addSubview(saveNicknameButton)
		setupViews()
	}
	private func setupRecognizer(){
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(saveNicknameButtonAction))
		saveNicknameButton.addGestureRecognizer(recognizer)
	}
	private func setUpConstraints(){
		let leadingConstant: CGFloat = 20
		let widthConstant: CGFloat = 100
		let spacingConstant: CGFloat = 20
		NSLayoutConstraint.activate(
			[
				scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
				scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
				scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
				scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),

				settingsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacingConstant),
				settingsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

				nicknameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: leadingConstant),
				nicknameLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: spacingConstant),

				saveNicknameButton.leadingAnchor.constraint(equalTo: textFiled.trailingAnchor, constant: spacingConstant),
				saveNicknameButton.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),

				textFiled.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: spacingConstant),
				textFiled.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
				textFiled.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
				textFiled.widthAnchor.constraint(equalToConstant: widthConstant),

				speedLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
				speedLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: spacingConstant),

				speedSlider.leadingAnchor.constraint(equalTo: speedLabel.trailingAnchor, constant: spacingConstant),
				speedSlider.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
				speedSlider.widthAnchor.constraint(equalToConstant: widthConstant),

				speedValueLabel.leadingAnchor.constraint(equalTo: speedSlider.trailingAnchor, constant: spacingConstant),
				speedValueLabel.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
				speedValueLabel.widthAnchor.constraint(equalToConstant: widthConstant),

				submarinesLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
				submarinesLabel.widthAnchor.constraint(equalToConstant: 3 * widthConstant),
				submarinesLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: spacingConstant),

				collectionView.topAnchor.constraint(equalTo: submarinesLabel.bottomAnchor, constant: spacingConstant),
				collectionView.leadingAnchor.constraint(equalTo: submarinesLabel.leadingAnchor),
				collectionView.heightAnchor.constraint(equalToConstant: 110),
				collectionView.widthAnchor.constraint(equalToConstant: 320),

				fishLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: spacingConstant),
				fishLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),

				collectionViewFish.topAnchor.constraint(equalTo: fishLabel.bottomAnchor, constant: spacingConstant),
				collectionViewFish.leadingAnchor.constraint(equalTo: fishLabel.leadingAnchor),
				collectionViewFish.heightAnchor.constraint(equalToConstant: 110),
				collectionViewFish.widthAnchor.constraint(equalToConstant: 320)


			]
		)
	}
	@objc private func sliderChangeAction(speedSlider: UISlider) {
		speedSlider.setValue(speedSlider.value.rounded(), animated: true)
		speedValueLabel.text = speedSlider.value.description
		settings.changeCurrentGameSpeed(gameSpeed: Double(speedSlider.value))
	}

	private func setupViews() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
		collectionViewFish.dataSource = self
		collectionViewFish.delegate = self
		collectionViewFish.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellFishIdentifier)
	}
	private func setupSubmarines() {
		for i in settings.allSubmarines {
			if let submarineImage = UIImage(named: i) {
				let	submarineImageView = UIImageView(image: submarineImage)
				submarineImageViewArray.append(submarineImageView)
			}
		}
	}

	private func setUpFishes() {
		for i in settings.allFish {
			if let fishImage = UIImage(named: i) {
				let fishImageView = UIImageView(image: fishImage)
				fishImageViewArray.append(fishImageView)
			}
		}
	}
	@objc private func saveNicknameButtonAction() {
		if let nickname = textFiled.text {
			print("Save", nickname)
			settings.changeNickname(nickname: nickname)
		}
	}
	private func setupNickname() {
		textFiled.text = settings.nickname

	}
	private func setupCurrentSpeed() {
		speedValueLabel.text = "\(settings.currentGameSpeed)"
		speedSlider.setValue(Float(settings.currentGameSpeed), animated: true)
	}
}
// MARK: - Extensions

extension SettingsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == collectionViewFish {
			return fishImageViewArray.count
		}
		return submarineImageViewArray.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == collectionViewFish {
			let cellFish = collectionViewFish.dequeueReusableCell(withReuseIdentifier: cellFishIdentifier, for: indexPath)
			cellFish.backgroundView = fishImageViewArray[indexPath.row]
			return cellFish
		}
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
		cell.backgroundView = submarineImageViewArray[indexPath.row]
		return cell
	}
}
extension SettingsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == collectionViewFish {
			settings.changeCurrentFish(fishIndex: indexPath.row)
		} else if self.collectionView == collectionView {
			settings.changeCurrentSubmarine(submarineIndex: indexPath.row)
		}
	}

}
