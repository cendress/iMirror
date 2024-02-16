//
//  CustomLinkView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct CustomLinkView: View {
  let title: String
  let url: String
  let imageName: String
  let backgroundColor: Color
  
  var body: some View {
    HStack {
      SettingsImageView(imageName: imageName, backgroundColor: backgroundColor)
      customLink(title: title, url: url)
    }
  }
  
  private func customLink(title: String, url: String) -> some View {
    HStack {
      Text(title)
        .font(.custom("Roboto-Regular", size: 18))
      
      Spacer()
      
      Image(systemName: "arrow.up.right")
        .foregroundColor(.blue)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if let url = URL(string: url) {
        UIApplication.shared.open(url)
      }
    }
  }
}
