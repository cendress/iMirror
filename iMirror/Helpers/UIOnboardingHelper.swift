//
//  UIOnboardingHelper.swift
//  iMirror
//
//  Created by Christopher Endress on 2/12/24.
//

import UIKit
import UIOnboarding

struct UIOnboardingHelper {
  // App Icon
  static func setUpIcon() -> UIImage {
    return Bundle.main.appIcon ?? .init(named: "onboarding-icon")!
  }
  
  // First Title Line
  // Welcome Text
  static func setUpFirstTitleLine() -> NSMutableAttributedString {
    .init(string: "Welcome to", attributes: [.foregroundColor: UIColor.label])
  }
  
  // Second Title Line
  // App Name
  static func setUpSecondTitleLine() -> NSMutableAttributedString {
    .init(string: Bundle.main.displayName ?? "Insignia", attributes: [
      .foregroundColor: UIColor.init(named: "camou")!
    ])
  }
  
  // Core Features
  static func setUpFeatures() -> Array<UIOnboardingFeature> {
    return .init([
      .init(icon: .init(named: "feature-1")!,
            title: "Search until found",
            description: "Over a hundred insignia of the Swiss Armed Forces – each redesigned from the ground up."),
      .init(icon: .init(named: "feature-2")!,
            title: "Enlist prepared",
            description: "Practice with the app and pass the rank test on the first run."),
      .init(icon: .init(named: "feature-3")!,
            title: "#teamarmee",
            description: "Add name tags of your comrades or cadre. Insignia automatically keeps every name tag you create in iCloud.")
    ])
  }
  
  // Notice Text
  static func setUpNotice() -> UIOnboardingTextViewConfiguration {
    return .init(icon: .init(named: "onboarding-notice-icon")!,
                 text: "Developed and designed for members of the Swiss Armed Forces.",
                 linkTitle: "Learn more...",
                 link: "https://www.lukmanascic.ch/portfolio/insignia",
                 tint: .init(named: "camou"))
  }
  
  // Continuation Title
  static func setUpButton() -> UIOnboardingButtonConfiguration {
    return .init(title: "Continue",
                 titleColor: .white, // Optional, `.white` by default
                 backgroundColor: .init(named: "camou")!)
  }
}
