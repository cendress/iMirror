//
//  UIOnboardingViewConfiguration+Extension.swift
//  iMirror
//
//  Created by Christopher Endress on 2/12/24.
//

import Foundation
import UIOnboarding

extension UIOnboardingViewConfiguration {
  static func setUp() -> UIOnboardingViewConfiguration {
    return UIOnboardingViewConfiguration(appIcon: UIOnboardingHelper.setUpIcon(),
                                         firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                                         secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                                         features: UIOnboardingHelper.setUpFeatures(),
                                         textViewConfiguration: UIOnboardingHelper.setUpNotice(),
                                         buttonConfiguration: UIOnboardingHelper.setUpButton())
  }
}
