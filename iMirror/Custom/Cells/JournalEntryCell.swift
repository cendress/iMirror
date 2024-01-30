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
  private let moodBackgroundView = UIView()
  
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
    contentView.addSubview(moodBackgroundView)
    contentView.addSubview(moodLabel)
    contentView.addSubview(emotionLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(noteLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(timeLabel)
    
    moodLabel.font = UIFont(name: "Roboto-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
    emotionLabel.font = UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
    titleLabel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
    noteLabel.font = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    dateLabel.font = UIFont(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
    timeLabel.font = UIFont(name: "Roboto-Thin", size: 12) ?? UIFont.systemFont(ofSize: 12)
    
    moodBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    moodLabel.translatesAutoresizingMaskIntoConstraints = false
    emotionLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    noteLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    
    moodBackgroundView.backgroundColor = UIColor.systemGray5
    moodBackgroundView.layer.cornerRadius = 15
    
    NSLayoutConstraint.activate([
      moodBackgroundView.topAnchor.constraint(equalTo: moodLabel.topAnchor, constant: -5),
      moodBackgroundView.leadingAnchor.constraint(equalTo: moodLabel.leadingAnchor, constant: -10),
      moodBackgroundView.trailingAnchor.constraint(equalTo: moodLabel.trailingAnchor, constant: 10),
      moodBackgroundView.bottomAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 5),
      
      moodLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      moodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      
      emotionLabel.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 5),
      emotionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      emotionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      titleLabel.topAnchor.constraint(equalTo: emotionLabel.bottomAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 5),
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      
      timeLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
      timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
      timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  func configure(with entry: JournalEntry) {
    moodLabel.text = entry.mood
    titleLabel.text = entry.title
    noteLabel.text = entry.note
    dateLabel.text = formatDate(entry.currentDate ?? Date())
    timeLabel.text = formatTime(entry.currentTime ?? Date())
    emotionLabel.text = (entry.emotion as? [String])?.joined(separator: ", ") ?? "No emotions"
  }
  
  private func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter.string(from: date)
  }
  
  private func formatTime(_ time: Date) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    return timeFormatter.string(from: time)
  }
}
