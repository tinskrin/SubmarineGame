//
//  GameViewController.swift
//  PodlodkaGame
//
//  Created by Kris on 23.08.2022.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {

	// MARK: Properties

	private let upButton = UIButton()
	private let downButton = UIButton()
	private var podlodkaImage = UIImageView()
	private let waterImage = UIImageView(frame: UIScreen.main.bounds)
	private let waterImageSecond = UIImageView(frame: UIScreen.main.bounds)
	private let buttonSize: CGFloat = 45
	private let fishSize: CGFloat = 90
	private let koralSize: CGFloat = 80
	private let lodkaSize: CGSize = CGSize(width: 180, height: 90)
	private let podlodkaSize: CGFloat = 100
	private var isGameStart = false
	private var timer = Timer()
	private var timerProgress = Timer()
	private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
	private let settings = GameSettings.shared
	private let fishTag = 1
	private let koralTag = 2
	private let lodkaTag = 3
	private let progressView: UIProgressView = UIProgressView()
	private var starGameTime: Date = .distantPast
	private let currentDate: Date = .now
	private let gameResultClass = GameResult.shared
	private let currentGameSpeed = Double(GameSettings.shared.currentGameSpeed)

	private let motionManager = CMMotionManager()
	private var isAccelerationStart = false
	private var devicePositionX: Double = 0


	// MARK: Lifecycle func

    override func viewDidLoad() {
        super.viewDidLoad()
		createBackgroundImage()
		createProgressView()
		createRecognizers()
		createImage()
		createButton()
		setupConstraints()
		gameStart()
		blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		view.addSubview(blurView)
		blurView.isHidden = true
    }

	// MARK: Flow funcs

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		timer.invalidate()
		timerProgress.invalidate()
		motionManager.stopAccelerometerUpdates()
	}

	private func createBackgroundImage(){
		waterImageSecond.center.x += view.bounds.width
		waterImage.image = UIImage(named: "water")
		waterImage.contentMode = UIView.ContentMode.scaleAspectFill
		self.view.insertSubview(waterImage, at: 0)
		waterImageSecond.image = UIImage(named: "water")
		waterImageSecond.contentMode = UIView.ContentMode.scaleAspectFill
		self.view.insertSubview(waterImageSecond, at: 0)
	}

	private func fishAppearance(countFish: Int, countKoral: Int, countLodka: Int) {
		for _ in Range(1...countFish){
			fishMove()
		}
		for _ in Range(1...countKoral){
			koralMove()
		}
		for _ in Range(1...countLodka){
			lodkaMove()
		}
	}
	private func createRecognizers(){
		let recognizerUp = UITapGestureRecognizer(target: self, action: #selector(upButtonAction))
		upButton.addGestureRecognizer(recognizerUp)
		let recognizerDown = UITapGestureRecognizer(target: self, action: #selector(downButtonAction))
		downButton.addGestureRecognizer(recognizerDown)
	}
	private func createButton(){
		upButton.setColor(color: .cyan)
		upButton.setTitle("up", for: .normal)
		upButton.setTitleColor(.black, for: .normal)
		upButton.rounded(radius: buttonSize / 2)
		view.addSubview(upButton)
		downButton.setColor(color: .cyan)
		downButton.setTitle("down", for: .normal)
		downButton.setTitleColor(.black, for: .normal)
		downButton.rounded(radius: buttonSize / 2)
		view.addSubview(downButton)
	}

	private func changePodlodkaPosition(on position: CGFloat) {
		if position > 0 {
			if podlodkaImage.frame.origin.y + position <= view.frame.maxY - podlodkaImage.frame.height {
				podlodkaImage.frame.origin.y += position
			} else {
				podlodkaImage.frame.origin.y = view.frame.maxY - podlodkaImage.frame.height
			}
		} else {
			if podlodkaImage.frame.origin.y + position >= 0 {
				podlodkaImage.frame.origin.y += position
			} else {
				podlodkaImage.frame.origin.y = 0
			}
		}
	}

	@objc private func upButtonAction(sender: UITapGestureRecognizer){
		changePodlodkaPosition(on: -10)
	}
	@objc private func downButtonAction(sender: UITapGestureRecognizer){
		changePodlodkaPosition(on: 10)
	}
	private func createImage(){
		podlodkaImage.frame = CGRect(x: view.frame.width / 10, y: view.frame.midY - podlodkaSize / 2, width: podlodkaSize, height: podlodkaSize)
		podlodkaImage.image = UIImage(named:settings.currentSubmarine)
		view.addSubview(podlodkaImage)
	}
	private func setupConstraints(){
		upButton.translatesAutoresizingMaskIntoConstraints = false
		downButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(
			[
				upButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
				upButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
				upButton.widthAnchor.constraint(equalToConstant: buttonSize),
				upButton.heightAnchor.constraint(equalToConstant: buttonSize),

				downButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
				downButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
				downButton.widthAnchor.constraint(equalToConstant: buttonSize),
				downButton.heightAnchor.constraint(equalToConstant: buttonSize),

			]
		)
	}
	@objc private func waterAction(){
		if !isGameStart{
			return
		}
		UIImageView.animate(withDuration: 0.01, delay: 0, options: [.curveLinear]) {
			let waterImageX = self.waterImage.frame.origin.x - 2
			let waterImageSecondX = self.waterImageSecond.frame.origin.x - 2
			self.waterImage.frame.origin = CGPoint(x: waterImageX, y: 0)
			self.waterImageSecond.frame.origin = CGPoint(x: waterImageSecondX, y: 0)
		} completion: { [weak self] end in
			guard let self = self else { return }
			if self.waterImageSecond.frame.origin.x <= 0 {
				self.waterImage.frame.origin = CGPoint(x: 0, y: 0)
				self.waterImageSecond.center.x  += self.view.bounds.width
			}
			self.waterAction()
		}
	}

	private func fishMove(){
		if !isGameStart{
			return
		}
		let fishImageView = UIImageView()
		fishImageView.image = UIImage(named: settings.currentFish)
		fishImageView.tag = fishTag
		fishImageView.clipsToBounds = true
		fishImageView.contentMode = .scaleAspectFit
		fishImageView.frame = CGRect(x: view.bounds.width, y: .random(in: self.view.frame.height/5.5...self.view.frame.height - fishSize), width: fishSize, height: fishSize)
		view.addSubview(fishImageView)
		let fishMoveY: CGFloat = .random(in: self.view.frame.height/5.5...self.view.frame.height - fishSize)
		fishImageView.frame.origin.y = fishMoveY
		UIImageView.animate(withDuration: 6 / currentGameSpeed, delay: .random(in: 0...15), options: [.curveLinear]) {
			fishImageView.frame.origin = CGPoint(x: -self.fishSize, y: fishMoveY)
		} completion: { [weak self] end in
			guard let self = self else { return }
			fishImageView.removeFromSuperview()
			self.fishMove()
		}
	}
	private func koralMove(){
		if !isGameStart{
			return
		}
		let koralImage = UIImageView()
		koralImage.tag = koralTag
		koralImage.image = UIImage(named: "koral")
		koralImage.contentMode = UIView.ContentMode.scaleAspectFill
		koralImage.frame = CGRect(x: view.bounds.width, y: view.frame.maxY - koralSize, width: koralSize, height: koralSize)
		view.addSubview(koralImage)
		UIImageView.animate(withDuration: 5 / currentGameSpeed, delay: .random(in: 0...20), options: [.curveLinear]) {
			koralImage.frame.origin = CGPoint(x: -self.koralSize, y: self.view.frame.maxY - self.koralSize)
		} completion: { [weak self] end in
			guard let self = self else { return }
			koralImage.removeFromSuperview()
			self.koralMove()
		}
	}
	private func lodkaMove(){
		if isGameStart == false {
			return
		}
		let lodkaImage = UIImageView()
		lodkaImage.tag = lodkaTag
		lodkaImage.image = UIImage(named: "lodka")
		lodkaImage.contentMode = UIView.ContentMode.scaleAspectFill
		lodkaImage.frame = CGRect(x: view.bounds.width + 30, y: view.frame.minY, width: lodkaSize.width, height: lodkaSize.height)
		view.addSubview(lodkaImage)
		UIImageView.animate(withDuration: 7 / currentGameSpeed, delay: .random(in: 0...30), options: [.curveLinear]) {
			lodkaImage.frame.origin = CGPoint(x: -self.lodkaSize.width, y: self.view.frame.minY)
		} completion: { [weak self] end in
			guard let self = self else { return }
			lodkaImage.removeFromSuperview()
			self.lodkaMove()
		}
	}

	private func gameStart() {
		startAcelerometerMoveLodka()
		isGameStart = true
		blurView.isHidden = true
		waterAction()
		fishAppearance(countFish: 4, countKoral: 3, countLodka: 2)
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkIntersects), userInfo: nil, repeats: true)
		timerProgress = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
		progressView.setProgress(0.5, animated: false)
		starGameTime = .now
		podlodkaImage.frame.origin.y = view.frame.midY - podlodkaSize / 2
	}

	@objc private func stopGame() {
		isGameStart = false
		let pictures = giveSubviews()
		for picture in pictures {
			picture.removeFromSuperview()
		}
		timerProgress.invalidate()
		timer.invalidate()
		let gameDuration = -starGameTime.timeIntervalSinceNow
		gameResultClass.saveGameResult(gameDuration: gameDuration, currentDate: currentDate)
		showAlert()
		motionManager.stopAccelerometerUpdates()
		isAccelerationStart = false
	}

	@objc private func checkIntersects() {
		let pictures = giveSubviews()
		for picture in pictures {
			let isIntersectsView = picture.layer.presentation()?.frame.intersects(podlodkaImage.frame)
			if isIntersectsView == true {
				stopGame()
				return
			}
		}
	}
	private func giveSubviews() -> [UIView] {
		let pictures = view.subviews.filter {
			$0.tag == fishTag || $0.tag == koralTag || $0.tag == lodkaTag
		}
		return pictures
	}
	private func showAlert(){
		blurView.isHidden = false
		view.bringSubviewToFront(blurView)
		let alert = UIAlertController(
			title: "Game over, \(settings.nickname)",
			message: (String(format: "Your score is %.1f", gameResultClass.allGameResult.last?.gameTime ?? 0)),
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "Restart game", style: .default, handler: { [weak self] _ in
			self?.gameStart()
		}))
		alert.addAction(UIAlertAction(title: "Back to main menu", style: .cancel, handler: { [weak self] _ in
			self?.navigationController?.popToRootViewController(animated: true)
		}))
		self.present(alert, animated: true)
	}
	private func createProgressView(){
		progressView.progress = 0.7
		progressView.progressTintColor = UIColor(red: 1.0, green: 0.21, blue: 0.33, alpha: 1)
		progressView.trackTintColor = .gray
		progressView.layer.cornerRadius = 6.5
		progressView.frame = CGRect(x: view.frame.minX - 100, y: view.frame.maxY / 2, width: view.frame.maxX / 4, height: view.frame.maxY / 4)
		progressView.transform = CGAffineTransform(rotationAngle: .pi / -2)
		progressView.setProgress(0.5, animated: false)
		view.addSubview(progressView)
	}
	@objc private func updateProgress(){
		if progressView.progress != 1 && podlodkaImage.frame.origin.y <= view.frame.height / 5 {
			self.progressView.progress += 0.03
		} else if progressView.progress == 0 {
			stopGame()
		} else {
			self.progressView.progress -= 0.02
		}
	}
}

// MARK: - Accelerometer

extension GameViewController {
	private func startAcelerometerMoveLodka(){
		if motionManager.isAccelerometerAvailable {
			motionManager.accelerometerUpdateInterval = 0.1
			motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data: CMAccelerometerData?, error: Error?) in
				guard let self = self else { return }
				if let acceleration = data?.acceleration {
					if !self.isAccelerationStart {
						self.isAccelerationStart = true
						self.devicePositionX = acceleration.x
					}
					if acceleration.x >= self.devicePositionX - 0.1 {
						self.changePodlodkaPosition(on: -10)
					} else if acceleration.x <= self.devicePositionX + 0.1 {
						self.changePodlodkaPosition(on: 10)
					}
				}
			}
		}
	}
}
