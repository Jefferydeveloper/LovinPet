//
//  MainViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/8.
//

import UIKit
import UserNotifications
import CoreData

protocol MainViewControllerDelegate : class{
   func text()
}

class MainViewController: UIViewController, CreateCollectionViewCellDelegate, UIGestureRecognizerDelegate, PetViewControllerDelegate {
    @IBOutlet weak var petCollectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var beginLabel: UILabel!
    
    @IBOutlet weak var petImageView: UIImageView!
    
    @IBOutlet weak var reminderTableView: UITableView!
    
    @IBOutlet weak var myShadowView: UIView!
    @IBOutlet weak var myInnerView: UIView!
      
    weak var delegate : MainViewControllerDelegate?
    
    var isTab: Bool = true
    
    var petData : [PetData] = []
    var tableData: [TableData] = []
    let item: [String] = [""]
    
    var indexSet: IndexSet = []
    //    var indexSet = [Int]()
    
    var indexPath: IndexPath?
    
    var currentDate = Date()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.queryFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.petCollectionView?.addGestureRecognizer(lpgr)
        
        if let index = UserDefaults.standard.object(forKey: "index") as? Int {
            if self.petData.count != 0 {
                let currentPet = petData[index - 1]
                self.nameLabel.text = currentPet.petName
                self.birthLabel.text = currentPet.birth
                self.sexLabel.text = currentPet.sex
                self.beginLabel.text = currentPet.beginDay
                self.petImageView.image = currentPet.image()
            }
        }
        
        myShadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myShadowView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        myShadowView.layer.shadowOpacity = 0.5
        myShadowView.layer.shadowRadius = 2
        myShadowView.layer.cornerRadius = 30
    }
    
    @IBAction func addReminderBtnPressed(_ sender: Any) {
        let context = CoreDataHelper.shared.managedObjectContext()
        
        let reminder = TableData(context: context)
        reminder.reminderTitle = "新提醒"
        reminder.reminderContent = "點選編輯內容"
        
        reminder.reminderDate = self.currentDate
        self.tableData.insert(reminder, at: 0)
        CoreDataHelper.shared.saveContext()
        
        let indexPath = IndexPath(row: 0, section: 0)
        reminderTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer) {
        actionSheet()
        
        let location = gestureRecognizer.location(in: self.petCollectionView)
        
        if let indexPath = self.petCollectionView.indexPathForItem(at: location) {
            self.indexPath = indexPath
            // get the cell at indexPath (the one you long pressed)
        } else {
            print("couldn't find index path")
        }
    }
    
    func actionSheet() {
        let actionSheet = UIAlertController(title: "編輯", message: "是否編輯寵物資訊", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        
        actionSheet.addAction(UIAlertAction(title: "刪除", style: .destructive, handler: { (action) in
            
            if let indexPath = self.indexPath {
                //刪除畫面相對應的位置(indexpath)的note物件
                let deleteData = self.petData.remove(at: indexPath.row - 1)
                let context = CoreDataHelper.shared.managedObjectContext()
                context.performAndWait {
                    context.delete(deleteData) //刪除記憶體中的note物件
                }
                self.petCollectionView.deleteItems(at: [indexPath])
                self.petCollectionView.reloadData()
                self.petImageView.reloadInputViews()
            }
            CoreDataHelper.shared.saveContext()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "確認", style: .default, handler: { (action) in
            
            if let navi = self.storyboard?.instantiateViewController(identifier: "barBtn") as? UINavigationController ,let petVC = navi.viewControllers[0] as? PetViewController {
                petVC.delegate = self
                
                if let indexPath = self.indexPath {
                    petVC.petData = self.petData[indexPath.row - 1]
                }
                self.present(navi, animated: true, completion: nil)
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func cratePet(_ sender: UIButton) {
        let context = CoreDataHelper.shared.managedObjectContext()
        let pet = NSEntityDescription.insertNewObject(forEntityName: "PetData", into: context) as! PetData
        
        pet.petName = ""
        pet.imageName = ""
        pet.sex = ""
        pet.birth = ""
        pet.beginDay = ""
        
        self.petData.insert(pet, at: 0)
        
        CoreDataHelper.shared.saveContext()
        CoreDataHelper.shared.managedObjectContext().rollback() // 取消按下後 取消存入coredata
        
        for index in indexSet {
            
            indexSet.insert( indexSet.remove(index)! + 1 )
            
        }
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        petCollectionView.insertItems(at: [indexPath])
        
        petCollectionView.reloadData()
    }
    
    //MARK: - CoreData
    func queryFromCoreData() {
        let context = CoreDataHelper.shared.managedObjectContext()
        let request = NSFetchRequest<PetData>.init(entityName: "PetData")
        let requestTableData = NSFetchRequest<TableData>.init(entityName: "TableData")
        context.performAndWait {
            do{
                let result : [PetData] = try context.fetch(request)
                let resultTableData : [TableData] = try context.fetch(requestTableData)
                self.petData = result
                self.tableData = resultTableData
            }catch {
                print("error while fetching coredata \(error)")
                self.petData = []
                self.tableData = []
            }
        }
    }
    
    func didFinishUpdate(petData: PetData) {
        
        self.nameLabel.text = petData.petName
        self.birthLabel.text = petData.birth
        self.sexLabel.text = petData.sex
        self.beginLabel.text = petData.beginDay
        self.petImageView.image = petData.image()
        
        self.petCollectionView.reloadData()
        
        CoreDataHelper.shared.saveContext()
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            print(indexPath.row)
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "createCell", for: indexPath) as! CreatePetCollectionViewCell
            collectionCell.delegate = self
            collectionCell.layer.borderWidth = 0.5
            collectionCell.layer.borderColor = UIColor.gray.cgColor
            return collectionCell
        } else {
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeCell", for: indexPath) as! ChangeCollectionViewCell
            collectionCell.layer.cornerRadius = collectionCell.frame.width / 2
            collectionCell.changeCellImageView.image = self.petData[indexPath.row - 1].image()
            return collectionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let cell = collectionView.cellForItem(at: indexPath) as? ChangeCollectionViewCell
        if indexPath.row == 0 {
            return
        }
        
        indexSet.removeAll()
        indexSet.insert(indexPath.row)
        
        if let collectionCell = collectionView.cellForItem(at: indexPath) {
            collectionCell.isSelected = true
        }

        let petData = self.petData[indexPath.row - 1]
        self.nameLabel.text = petData.petName
        self.birthLabel.text = petData.birth
        self.sexLabel.text = petData.sex
        self.beginLabel.text = petData.beginDay
        self.petImageView.image = petData.image()
        
        UserDefaults.standard.setValue(indexPath.row, forKey: "index")
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource, ReminderEditedViewControllerDelegate
extension MainViewController: UITableViewDataSource, ReminderEditedViewControllerDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.textLabel?.text = tableData[indexPath.row].reminderTitle
        cell.detailTextLabel?.text = tableData[indexPath.row].reminderContent
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.string(from: tableData[indexPath.row].reminderDate)
        
        cell.dateTextLabel.text = "\(formatter.string(from: tableData[indexPath.row].reminderDate))"
//        let labelCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reminderSegue" {
            if let reminderVC = segue.destination as? ReminderEditedViewController {
                if let indexPath = self.reminderTableView.indexPathForSelectedRow {
                    let reminder = tableData[indexPath.row]
                    reminderVC.reminderData = reminder
                    reminderVC.delegate = self
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tableData = self.tableData.remove(at: indexPath.row)
            let context = CoreDataHelper.shared.managedObjectContext()
            
            context.delete(tableData)
            CoreDataHelper.shared.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didFinishUpdate(tableData: TableData) {
        let index = self.tableData.firstIndex(of : tableData)
        
        if let index1 = index{
        let indexPath = IndexPath(row: index1, section: 0)
            self.reminderTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        CoreDataHelper.shared.saveContext()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.reminderTableView.deselectRow(at: indexPath, animated: true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.string(from: tableData[indexPath.row].reminderDate)
    }
}
