//
//  GameResult.swift
//  PodlodkaGame
//
//  Created by Kris on 21.09.2022.
//

import Foundation

class GameResult: Codable {

	static let shared = GameResult()

	private (set) var allGameResult: [Game] = []
	private init() {
		allGameResult = UserDefaults.standard.value([Game].self, forKey: "allGameResult")?
			.sorted { $0.gameTime > $1.gameTime } ?? []
	}

	func saveGameResult(gameDuration: Double, currentDate: Date){
		allGameResult.append(Game(name: GameSettings.shared.nickname, gameTime: gameDuration, gameDate: currentDate))
		UserDefaults.standard.set(encodable: allGameResult, forKey: "allGameResult")
	}
}

struct Game: Codable {
	let name: String
	let gameTime: Double
	let gameDate: Date
}
