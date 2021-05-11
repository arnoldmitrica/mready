//
//  UIView.swift
//  mready
//
//  Created by Arnold Mitricã on 10.05.2021.
//
import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
