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
      
      VStack(alignment: .center, spacing: 20) {
        Text("Acknowledgments")
          .font(.custom("Roboto-Bold", size: 22))
          .padding(.bottom, 10)
          .frame(maxWidth: .infinity, alignment: .center)
        
        Text("Credit to the iOS developer community, whose creativity and hard work continue to inspire me every day.")
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity, alignment: .center)
        
        Text("Special thanks to the creators of the UIOnboarding library, which greatly enhanced this project. Visit their GitHub repository: https://github.com/lascic/UIOnboarding.")
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity, alignment: .center)
        
        Text("I also wish to extend my appreciation to Pixabay, for providing financially accessible, high-quality videos and audio used in this app.")
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity, alignment: .center)
        
        HStack {
          Text("🔗 Connect with me:")
          Link("@chrisendress_io", destination: URL(string: "https://twitter.com/chrisendress_io")!)
        }
        
        Spacer()
      }
      .padding()
      .font(.custom("Roboto-Regular", size: 18))
    }
    
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

#Preview {
  AcknowledgmentsView()
}

