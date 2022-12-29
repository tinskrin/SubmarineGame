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
		allGameResult = UserDefaults.standard.value([Game].self, forKey: "allGameResult") ?? []
		print(allGameResult)
	}

	func saveGameResult(gameDuration: Double, currentDate: Date){
		allGameResult.append(Game.init(name: GameSettings.shared.nickname, gameTime: gameDuration, gameDate: currentDate))
		UserDefaults.standard.set(encodable: allGameResult, forKey: "allGameResult")
		print(allGameResult)
		print(gameDuration)
	}
}

struct Game: Codable {
	let name: String
	let gameTime: Double
	let gameDate: Date
}


extension UserDefaults {

	func set<T: Encodable>(encodable: T, forKey key: String) {
		if let data = try? JSONEncoder().encode(encodable) {
			set (data, forKey: key)
		}
	}

	func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
		if let data = object(forKey: key) as? Data,
		   let value = try? JSONDecoder().decode(type, from: data) {
			return value
		}
		return nil
	}
}
