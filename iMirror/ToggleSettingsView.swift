//
//  ToggleSettingsView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct ToggleSettingsView: View {
  @Binding var isEnabled: Bool
  let imageName: String
  let title: String
  let backgroundColor: Color
  
  var body: some View {
    Toggle(isOn: $isEnabled) {
      HStack {
        SettingsImageView(imageName: imageName, backgroundColor: backgroundColor)
        Text(title)
          .font(.custom("Roboto-Regular", size: 18))
      }
    }
  }
}
