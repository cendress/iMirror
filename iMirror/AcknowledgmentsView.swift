//
//  AcknowledgmentsView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI

struct AcknowledgmentsView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    ZStack {
      
      Color(UIColor(named: "FormBackgroundColor") ?? UIColor.systemBackground)
        .edgesIgnoringSafeArea(.all)
      
      Text("Acknowledgments content here")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
              self.presentationMode.wrappedValue.dismiss()
            }) {
              Image(systemName: "chevron.left.circle.fill")
                .foregroundColor(Color(UIColor(named: "AppColor") ?? UIColor.systemBlue))
            }
          }
        }
        .navigationBarBackButtonHidden(true)
    }
  }
}

#Preview {
  AcknowledgmentsView()
}
