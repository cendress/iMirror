//
//  QuoteProvider.swift
//  iMirror
//
//  Created by Christopher Endress on 2/17/24.
//

import Foundation

class QuoteProvider {
  static let shared = QuoteProvider()
  
  private(set) var quotes: [Quote] = []
  private var usedQuotes: [Quote] = [] {
    didSet {
      saveUsedQuotes()
    }
  }
  
  private init() {
    loadQuotes()
    loadUsedQuotes()
  }
  
  private func loadQuotes() {
    guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
      print("Error loading quotes from JSON")
      return
    }
    
    do {
      let decoder = JSONDecoder()
      quotes = try decoder.decode([Quote].self, from: data)
    } catch {
      print("Error decoding quotes: \(error)")
    }
  }
  
  private func saveUsedQuotes() {
    if let data = try? JSONEncoder().encode(usedQuotes) {
      UserDefaults.standard.set(data, forKey: "UsedQuotes")
    }
  }
  
  private func loadUsedQuotes() {
    if let data = UserDefaults.standard.data(forKey: "UsedQuotes"),
       let savedQuotes = try? JSONDecoder().decode([Quote].self, from: data) {
      usedQuotes = savedQuotes
    }
  }
  
  func getRandomQuote() -> Quote {
    if quotes.isEmpty {
      quotes = usedQuotes
      usedQuotes.removeAll()
    }
    guard let quote = quotes.randomElement() else {
      return Quote(text: "Happiness is not something ready made. It comes from your own actions.", author: "Dalai Lama")
    }
    usedQuotes.append(quote)
    quotes.removeAll { $0.text == quote.text }
    return quote
  }
}
