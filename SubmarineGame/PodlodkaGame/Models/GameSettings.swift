//
//  GameSettings.swift
//  PodlodkaGame
//
//  Created by Kris on 19.09.2022.
//

import Foundation

private extension String {
	static let submarineKey = "submarine"
	static let fishKey = "fish"
	static let nicknameKey = "nickname"
	static let speedKey = "gameSpeed"
	static let controlKey = "gameControl"
}

final class GameSettings {

	static let shared = GameSettings()

	private (set) var allSubmarines: [String] = ["podlodka","submarineTwo","submarineThree","submarineFourth","submarineFifth", "submarineSixth"]
	private (set) var allFish: [String] = ["fish", "fishOne", "fishTwo", "fishThree", "fishFour", "fishFive", "fishSix", "fishSeven", "fishEigth", "fishNine"]
	private (set) var currentSubmarine: String
	private (set) var nickname: String
	private (set) var currentGameSpeed: Double = 1.0
	private (set) var currentFish: String
	private (set) var currentControl: GameType

	private init() {
		currentSubmarine = allSubmarines[0]
		currentFish = allFish[0]
		nickname = ""
		currentControl = .button
		setupSavedSettings()
	}

	func changeNickname(nickname: String) {
		self.nickname = nickname
		UserDefaults.standard.set(nickname, forKey: .nicknameKey)
	}

	func changeCurrentSubmarine(submarineIndex: Int) {
		currentSubmarine = allSubmarines[submarineIndex]
		UserDefaults.standard.set(currentSubmarine, forKey: .submarineKey)
	}

	func changeCurrentGameSpeed(gameSpeed: Double) {
		currentGameSpeed = gameSpeed
		UserDefaults.standard.set(currentGameSpeed, forKey: .speedKey)
	}

	func changeCurrentFish(fishIndex: Int) {
		currentFish = allFish[fishIndex]
		UserDefaults.standard.set(currentFish, forKey: .fishKey)
	}

	func changeGameType(for type: GameType) {
		currentControl = type
		UserDefaults.standard.set(encodable: type, forKey: .controlKey)
	}
	
	private func setupSavedSettings() {
		if let currentSubmarine = UserDefaults.standard.value(forKey: .submarineKey) as? String {
			self.currentSubmarine = currentSubmarine
		}
		if let currentFish = UserDefaults.standard.value(forKey: .fishKey) as? String {
			self.currentFish = currentFish
		}
		if let nickname = UserDefaults.standard.value(forKey: .nicknameKey) as? String {
			self.nickname = nickname
		}
		if let gameSpeed = UserDefaults.standard.value(forKey: .speedKey) as? Double {
			currentGameSpeed = gameSpeed
		}
		if let currentControl = UserDefaults.standard.value(GameType.self, forKey: .controlKey) {
			self.currentControl = currentControl
		}
	}
}
