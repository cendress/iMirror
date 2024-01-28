//
//  JournalEntryCell.swift
//  iMirror
//
//  Created by Christopher Endress on 1/28/24.
//

import UIKit

class JournalEntryCell: UITableViewCell {
  
  // Properties
  private let moodLabel = UILabel()
  private let emotionLabel = UILabel()
  private let titleLabel = UILabel()
  private let noteLabel = UILabel()
  private let dateLabel = UILabel()
  private let timeLabel = UILabel()
  
  // Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }
  
  // Configuration
  private func setupCell() {
    
  }
  
  func configure(with entry: JournalEntry) {
    moodLabel.text = entry.mood
    titleLabel.text = entry.title
    noteLabel.text = entry.note
    
    if let currentDate = entry.currentDate {
      dateLabel.text = formatDate(currentDate)
    } else {
      dateLabel.text = "N/A"
    }
    
    if let currentTime = entry.currentTime {
      timeLabel.text = formatTime(currentTime)
    } else {
      timeLabel.text = "N/A"
    }
    
    if let emotionsArray = entry.emotion as? [String] {
      emotionLabel.text = emotionsArray.joined(separator: ", ")
    } else {
      emotionLabel.text = "No emotions"
    }
  }
  
  private func formatDate(_ date: Date) -> String {
    
  }
  
  private func formatTime(_ time: Date) -> String {
    
  }
}
