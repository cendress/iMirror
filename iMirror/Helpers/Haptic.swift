//
//  Haptic.swift
//  iMirror
//
//  Created by Christopher Endress on 6/16/25.
//

import UIKit

enum Haptic {
    private static let impactLight = UIImpactFeedbackGenerator(style: .light)
    private static let impactMed = UIImpactFeedbackGenerator(style: .medium)
    private static let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

    static func prepare() {
        impactLight.prepare()
        impactMed.prepare()
        impactHeavy.prepare()
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        switch style {
        case .light:  impactLight.impactOccurred()
        case .medium: impactMed.impactOccurred()
        case .heavy:  impactHeavy.impactOccurred()
        case .soft: break
        case .rigid: break
        @unknown default: break
        }
    }
}
