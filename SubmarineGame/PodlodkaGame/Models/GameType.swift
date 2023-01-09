//
//  GameType.swift
//  PodlodkaGame
//
//  Created by Why on 01.01.2023.
//

import Foundation

enum GameType: Int, CaseIterable, CustomStringConvertible,Codable {

	case button
	case acelerometer

	var description: String {
		switch self {
		case .button:
			return "Button"
		case .acelerometer:
			return "Acelerometer"
		}
	}

	static var allTypes: [String] {
		allCases.map { $0.description }
	}
}
