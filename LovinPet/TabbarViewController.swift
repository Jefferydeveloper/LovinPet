//
//  TabbarViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/8.
//

import UIKit

class TabbarViewController: UITabBarController/*, UITabBarControllerDelegate*/ {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//       let index = tabBarController.viewControllers?.firstIndex(of: viewController)
//        if index == 1 {
//            let imgpicker = UIImagePickerController()
//            imgpicker.sourceType = .savedPhotosAlbum
//            self.present(imgpicker, animated: true, completion: nil)
//            return false
//        }
//        return true
//    }
//
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//    }
}
