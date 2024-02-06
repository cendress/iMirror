//
//  DatePickerVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/6/24.
//

import UIKit

class DatePickerVC: UIViewController {
  var datePicker: UIDatePicker!
  var completion: ((Date) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDatePicker()
  }
  
  private func setupDatePicker() {
    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .inline
    datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    
    view.addSubview(datePicker)
    
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    // add Done and Cancel buttons or handle dismissal with a gesture
  }
  
  @objc func dateChanged(_ sender: UIDatePicker) {
    // Call completion handler if you want to auto-dismiss on date change
    // or use a Done button to call this
    completion?(sender.date)
  }
}
