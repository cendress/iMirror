//
//  BackgroundView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct BackgroundView: View {
  var body: some View {
    Color(UIColor { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    })
    .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
  BackgroundView()
}
