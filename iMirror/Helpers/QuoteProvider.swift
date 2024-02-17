//
//  QuoteProvider.swift
//  iMirror
//
//  Created by Christopher Endress on 2/17/24.
//

import Foundation

class QuoteProvider {
  static let shared = QuoteProvider()
  
  private init() {}
  
  let quotes = [
    Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
    Quote(text: "Life is what happens when you're busy making other plans.", author: "John Lennon"),
    Quote(text: "The purpose of our lives is to be happy.", author: "Dalai Lama"),
  ]
  
  func getRandomQuote() -> Quote {
    quotes.randomElement() ?? Quote(text: "Happiness is not something ready made. It comes from your own actions.", author: "Dalai Lama")
  }
}
