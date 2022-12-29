//
//  UIView+extensions.swift
//  PodlodkaGame
//
//  Created by Kris on 09.09.2022.
//

import Foundation
import UIKit

extension UIView {
	func rounded(radius: CGFloat = 15) {
		self.layer.cornerRadius = radius
	}
	func setColor(color: UIColor = .black) {
		self.backgroundColor = color
	}
	func dropShadow() {
		layer.masksToBounds = false
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.5
		layer.shadowOffset = CGSize(width: 10, height: 10)
		layer.shadowRadius = 10
		layer.shadowPath = UIBezierPath(rect: bounds).cgPath // тень для квадратов, прямоугольников
		layer.shouldRasterize = true
	}
}
