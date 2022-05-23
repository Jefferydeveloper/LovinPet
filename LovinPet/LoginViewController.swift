//
//  LoginViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/8.
//

import UIKit
import AVFoundation
//import FBSDKCoreKit
//import FBSDKLoginKit

class LoginViewController: UIViewController/*, LoginButtonDelegate*/ {
    
//    @IBOutlet weak var pictureView: FBProfilePictureView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var loginButton: FBLoginButton!
    @IBOutlet weak var videoView: UIView!
    
    var player: AVPlayer?
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
//        self.loginButton.permissions = ["public_profile", "email"]
//        self.loginButton.delegate = self
        // Facebook登入後，會給系統access token(fb生成的一串亂碼)
        // 用此方法可以知道access token有沒有改變
//        Profile.enableUpdatesOnAccessTokenChange(true)
        // 以下方法接收access token
//        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: .ProfileDidChange, object: nil)
//        self.updateProfile()
//        self.requestMe()
        
        //let user = UserDefaults.standard.object(forKey: "username")
//        if let token = AccessToken.current, !token.isExpired { // 取得token現在狀態 並確認沒有過期
//            //login
//            let storybaord = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storybaord.instantiateViewController(identifier: "tabbarVC")
//            if let scene = UIApplication.shared.connectedScenes.first, let delegate = scene.delegate as? SceneDelegate {
//                delegate.window?.rootViewController = loginVC
//            }
//        }
        
    }
    
//    @objc func updateProfile() {
//        // user登入後, 可用Profile.current取得使用者資訊
//        if let profile = Profile.current {
//            self.pictureView.profileID = profile.userID
//            self.nameLabel.text = profile.name
//        }
//    }
    
//    func requestMe() {
//        // 先判斷是否有token存在,有Token表示使用者有login
//        if AccessToken.current != nil {
//            let request = GraphRequest(graphPath: "me",
//                                       parameters:["fields":"email,birthday"])
//            request.start(completionHandler: { (connection, result, error) -> Void in
//                //                print(result)
//                let info = result as! Dictionary<String,AnyObject>
//                if let email = info["email"] {
//                    print("email  = \(email)")
//                }
//                if let birthday = info["birthday"] {
//                    print("birthday = \(birthday)")
//                }
//            })
//        }
//    }
    
    // MARK: - LoginButtonDelegate
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        //UserDefaults.standard.set("Jeffery", forKey: "username")
//        let tabbarVC = self.storyboard?.instantiateViewController(identifier: "tabbarVC")
//        self.view.window?.rootViewController = tabbarVC
//    }
    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        // 登出時清除大頭貼及名字
//        self.pictureView.profileID = ""
//        self.nameLabel.text = nil
//    }
    
    private func setupView() {
        guard let path = Bundle.main.path(forResource: "CatVideo", ofType: "mp4") else {
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.opacity = 0.6
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.videoView.layer.addSublayer(playerLayer)
        self.videoView.layer.insertSublayer(playerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewDidPlayToEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player!.currentItem)
        
        player?.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    
    @objc func viewDidPlayToEnd(_ notification: Notification) {
        player!.seek(to: CMTime.zero)
    }
    
}
