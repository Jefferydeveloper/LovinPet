//
//  SettingViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/8.
//

import UIKit
import FBSDKLoginKit
import MessageUI

class SettingViewController: UIViewController/*, LoginButtonDelegate*/ {
    
    //    @IBOutlet weak var loginButton: FBLoginButton!
    
    var sectionTitles = ["一般", "關於"]
    var sectionContent = [[(ver: "1.0.0", text: "支援")], [(ver: "1.0.0",text: "版本")]]

    @IBOutlet weak var settingTableView: UITableView!
    
    var alertController : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.tableFooterView = UIView()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        //        self.loginButton.permissions = ["public_profile", "email"]
        //        self.loginButton.delegate = self
        
    }
    
    //    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    //
    //    }
    //
    //    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    //        if let view = self.storyboard?.instantiateViewController(identifier: "loginVC") {
    //        UIApplication.shared.keyWindow?.rootViewController = view
    //        }
    //    }
    //
    //    @IBAction func sendEmailBtnPressed(_ sender: UIButton) {
    //        showMailComposer()
    //    }
    //
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            // Show alert informing the user
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["jeffery25509927@gamil.com"])
        composer.setSubject("LovinPet - ")
        composer.setMessageBody("Hello Support Team: ", isHTML: false)
        
        let alert = UIAlertController(title: "歡迎任何意見或問題，謝謝", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
            self.present(composer, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.settingTableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: nil, message: "目前功能開發中，敬請期待", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.alertController = nil
        }
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                showMailComposer()
            } else if indexPath.row == 1 {
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        case 1:
            return
        default:
            print("default.")
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        
        let cellData = sectionContent[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellData.text
        
        if indexPath.section == 1 {
            cell.settingTextLabel.text = cellData.ver
        } else {
            cell.settingTextLabel.text = ""
        }
        return cell
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
        @unknown default:
            print("")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

