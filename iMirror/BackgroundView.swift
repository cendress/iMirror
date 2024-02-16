//
//  BackgroundView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct BackgroundView: View {
  var body: some View {
    Color(UIColor(named: "BackgroundColor") ?? .systemBackground)
    .edgesIgnoringSafeArea(.all)
  }
}
