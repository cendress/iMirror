//
//  SettingsImage.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct SettingsImageView: View {
  var imageName: String
  var backgroundColor: Color
  
  var body: some View {
    Image(systemName: imageName)
      .resizable()
      .scaledToFit()
      .frame(width: 15, height: 15)
      .padding(6)
      .background(backgroundColor)
      .foregroundColor(.white)
      .cornerRadius(7)
  }
}

#Preview {
  SettingsImageView(imageName: "pencil", backgroundColor: .blue)
}
