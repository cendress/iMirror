//
//  JournalEntryCell.swift
//  iMirror
//
//  Created by Christopher Endress on 1/28/24.
//

import UIKit

class JournalEntryCell: UITableViewCell {
  
  private let moodLabel = UILabel()
  private var emotionLabels = [UILabel]()
  private let titleLabel = UILabel()
  private let noteLabel = UILabel()
  private let dateLabel = UILabel()
  private let timeLabel = UILabel()
  private let moodBackgroundView = UIView()
  
  private var lastEmotionLabel: UILabel?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }
  
  private func setupCell() {
    contentView.addSubview(moodBackgroundView)
    contentView.addSubview(moodLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(noteLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(timeLabel)
    
    configureAppearance()
    setupConstraints()
  }
  
  private func configureAppearance() {
    moodLabel.font = UIFont(name: "Roboto-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
    titleLabel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
    noteLabel.font = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    dateLabel.font = UIFont(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
    timeLabel.font = UIFont(name: "Roboto-Thin", size: 12) ?? UIFont.systemFont(ofSize: 12)
    
    moodBackgroundView.backgroundColor = UIColor.systemGray5
    moodBackgroundView.layer.cornerRadius = 20
    
    contentView.backgroundColor = UIColor.white
    contentView.layer.cornerRadius = 20
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    contentView.layer.shadowRadius = 4
    contentView.layer.shadowOpacity = 0.1
    contentView.clipsToBounds = false
  }
  
  private func setupConstraints() {
    moodBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    moodLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    noteLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      moodBackgroundView.centerYAnchor.constraint(equalTo: moodLabel.centerYAnchor),
      moodBackgroundView.centerXAnchor.constraint(equalTo: moodLabel.centerXAnchor),
      moodBackgroundView.widthAnchor.constraint(equalTo: moodLabel.widthAnchor, constant: 20),
      moodBackgroundView.heightAnchor.constraint(equalTo: moodBackgroundView.widthAnchor),
      
      moodLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      moodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      
      titleLabel.topAnchor.constraint(equalTo: moodLabel.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: moodBackgroundView.trailingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -10),
      
      timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      noteLabel.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 10),
      noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
    ])
  }
  
  func configure(with entry: JournalEntry) {
    moodLabel.text = entry.mood
    titleLabel.text = entry.title
    noteLabel.text = entry.note
    dateLabel.text = formatDate(entry.currentDate ?? Date())
    timeLabel.text = formatTime(entry.currentTime ?? Date())
    createEmotionLabels(for: entry.emotion as? [String] ?? [])
  }
  
  private func createEmotionLabels(for emotions: [String]) {
    emotionLabels.forEach { $0.removeFromSuperview() }
    emotionLabels.removeAll()
    
    var previousLabel: UILabel? = nil
    for emotion in emotions {
      let label = UILabel()
      label.text = " \(emotion) "
      label.backgroundColor = UIColor.systemGray6
      label.layer.cornerRadius = 10
      label.clipsToBounds = true
      label.textAlignment = .center
      label.font = UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
      contentView.addSubview(label)
      label.translatesAutoresizingMaskIntoConstraints = false
      
      let topConstraint = label.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10)
      let leadingConstraint = label.leadingAnchor.constraint(equalTo: previousLabel == nil ? contentView.leadingAnchor : previousLabel!.trailingAnchor, constant: 20)
      
      NSLayoutConstraint.activate([topConstraint, leadingConstraint])
      
      if previousLabel == nil {
        let bottomConstraint = label.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -10)
        bottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([bottomConstraint])
      }
      
      previousLabel = label
      emotionLabels.append(label)
    }
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
