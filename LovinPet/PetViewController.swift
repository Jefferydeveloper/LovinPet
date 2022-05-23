//
//  PetViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/24.
//

import UIKit

protocol PetViewControllerDelegate : class{
   func didFinishUpdate(petData : PetData)
}

class PetViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var petImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var getHomeTextField: UITextField!
    
    var petData : PetData!
    
    weak var delegate : PetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PetViewController.back))
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let doneBarButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PetViewController.done))
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        nameTextField.delegate = self
        sexTextField.delegate = self
        birthTextField.delegate = self
        getHomeTextField.delegate = self
        
        self.petImageView.image = self.petData.image()
        self.nameTextField.text = self.petData.petName
        self.sexTextField.text = self.petData.sex
        self.birthTextField.text = self.petData.birth
        self.getHomeTextField.text = self.petData.beginDay
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // done
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done(sender: UIBarButtonItem) {
        
        self.petData?.petName = self.nameTextField.text
        self.petData?.sex = self.sexTextField.text
        self.petData?.birth = self.birthTextField.text
        self.petData?.beginDay = self.getHomeTextField.text
        
        if let image = self.petImageView.image {
            let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
            let docUrl = homeUrl.appendingPathComponent("Documents")
            let fileName = "\(self.petData.petID).jpg"
            let fileUrl = docUrl.appendingPathComponent(fileName)
            print("home \(NSHomeDirectory())")
            
            if let imageData = image.jpegData(compressionQuality: 1) {
                do {
                    try imageData.write(to: fileUrl, options: .atomic)
                    
                    self.petData.imageName = fileName
                } catch {
                    print("error \(error)")
                }
            }
        }
        self.delegate?.didFinishUpdate(petData: petData)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageBtnPressed(_ sender: UIButton) {
        //imageBtnPressed
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    //選完照片後會跳進來
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.petImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}

// Pack up keyboard.
extension PetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //       self.nameTextField.resignFirstResponder()
        self.nameTextField.endEditing(true)
        self.sexTextField.endEditing(true)
        self.birthTextField.endEditing(true)
        self.getHomeTextField.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextField.endEditing(true)
        self.sexTextField.endEditing(true)
        self.birthTextField.endEditing(true)
        self.getHomeTextField.endEditing(true)
    }
}
