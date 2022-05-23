//
//  ReminderEditedViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2021/1/6.
//

import UIKit
import UserNotifications

protocol ReminderEditedViewControllerDelegate : class{
    func didFinishUpdate(tableData : TableData)
}

class ReminderEditedViewController: UIViewController, MainViewControllerDelegate {
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    
    var reminderData : TableData!
    weak var delegate : ReminderEditedViewControllerDelegate?
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextfield.text = self.reminderData.reminderTitle
        self.bodyTextField.text = self.reminderData.reminderContent
    }
    
    @IBAction func reminderDoneBtnPressed(_ sender: Any) {
        //        if let titleText = titleTextfield.text, !titleText.isEmpty,
        //           let bodyText = bodyTextField.text, !bodyText.isEmpty {
        //            let targetDate = reminderDatePicker.date
        //
        //            completion?(titleText, bodyText, targetDate)
        //        }
        self.reminderData.reminderTitle = self.titleTextfield.text
        self.reminderData.reminderContent = self.bodyTextField.text
        self.reminderData.reminderDate = self.reminderDatePicker.date
        
        self.delegate?.didFinishUpdate(tableData: reminderData)
        self.navigationController?.popViewController(animated: true)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                self.text()
            } else if error != nil {
                print("error occured")
            }
        }
    }
    
    func text() {
        DispatchQueue.main.async {
            let content = UNMutableNotificationContent()
            
            content.title = self.reminderData.reminderTitle ?? ""
            content.body = self.reminderData.reminderContent ?? ""
            content.sound = .default
            
            let date = self.reminderDatePicker.date
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Somethomg went wrong.")
                }
            })
        }
    }
}
