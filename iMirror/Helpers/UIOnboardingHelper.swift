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
    return Bundle.main.appIcon ?? .init(named: "AppIcon")!
  }
  
  // First Title Line
  // Welcome Text
  static func setUpFirstTitleLine() -> NSMutableAttributedString {
    .init(string: "Welcome to", attributes: [.foregroundColor: UIColor.label])
  }
  
  // Second Title Line
  // App Name
  static func setUpSecondTitleLine() -> NSMutableAttributedString {
    .init(string: Bundle.main.displayName ?? "iMirror", attributes: [
      .foregroundColor: UIColor.init(named: "AppColor")!
    ])
  }
  
  // Core Features
  static func setUpFeatures() -> [UIOnboardingFeature] {
    return [
      .init(icon: UIImage(systemName: "person.text.rectangle")!,
            title: "Emotional Check-In",
            description: "Begin your journey with an intuitive emotional check-in, guiding you towards understanding your current state of mind."),
      .init(icon: UIImage(systemName: "headphones.circle")!,
            title: "Meditation",
            description: "Experience tools that facilitate mindfulness, aiding in processing and greater insight."),
      .init(icon: UIImage(systemName: "note.text")!,
            title: "Reflective Journaling",
            description: "Culminate your session with insightful journaling, capturing your thoughts and growth post-meditation."),
      .init(icon: UIImage(systemName: "quote.bubble")!,
            title: "Daily Inspiration",
            description: "Receive motivational quotes daily to foster a positive mindset and consistent mindfulness practice.")
    ]
  }
  
  // Notice Text
  static func setUpNotice() -> UIOnboardingTextViewConfiguration {
    return .init(icon: UIImage(systemName: "info.circle")!,
                 text: "iMirror is committed to supporting your journey towards emotional well-being, respecting your privacy every step of the way.",
                 linkTitle: "Discover more about iMirror",
                 link: "https://www.example.com/about",
                 tint: UIColor(named: "AppColor"))
  }
  
  // Continuation Title
  static func setUpButton() -> UIOnboardingButtonConfiguration {
    return .init(title: "Continue",
                 titleColor: .white, // Optional, `.white` by default
                 backgroundColor: .init(named: "AppColor")!)
  }
}
