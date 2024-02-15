//
//  SettingsImage.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct SettingsImage: View {
  var imageName: String
  var backgroundColor: Color
  
  var body: some View {
    Image(systemName: imageName)
      .resizable()
      .scaledToFit()
      .frame(width: 24, height: 24)
      .padding(8)
      .background(backgroundColor)
      .foregroundColor(.white)
      .cornerRadius(5)
  }
}

#Preview {
  SettingsImage(imageName: "pencil", backgroundColor: .blue)
}
