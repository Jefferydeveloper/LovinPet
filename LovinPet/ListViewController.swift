//
//  MapViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/8.
//

import UIKit
import MapKit
import KRProgressHUD

class ListViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var hospitalTableView: UITableView!
    
    let jsDecoder = JSONDecoder()
    var petHospital = [FinalResult]()
    var chinesePetHospital: [String] = []
    
    var searchDownload: [hospital] = []
    
    var hospitalImages = ["hospital", "hospital2", "hospital3", "hospital4", "hospital5", "hospital6", "hospital7", "hospital8", "hospital9", "hospital10"]
    
    var hospitalAddr: [String] = []
    var hospitalPhone: [String] = []
    let geocoder = CLGeocoder()
    
    var searchHospitalController: UISearchController!
    
    var alertController : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Circle running
        KRProgressHUD.show()
        navigationController?.navigationBar.prefersLargeTitles =  true
        
        searchHospitalController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchHospitalController
        searchHospitalController.searchBar.placeholder = "請輸入地址"
        
        requestLocation()
        
        hospitalTableView.delegate = self
        hospitalTableView.dataSource = self
        searchHospitalController.searchResultsUpdater = self
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "資料發生異常，請重新連線後再作業", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.alertController = nil
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestLocation() {
        let hospitalRequset = "https://data.taipei/api/v1/dataset/aaeb65de-a766-4101-91d0-b2293f86c154?scope=resourceAquire&q=&limit=1000&offset="
        
        guard let url = URL(string: hospitalRequset) else {
            print("urlError: error in URL.")
            return
        }
        
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let res = try self.jsDecoder.decode(FinalResult.self, from: data)
                    self.petHospital = [res]
                    let countnum = self.petHospital[0].result.count
                    
                    for i in 0..<countnum {
                        self.chinesePetHospital.append(self.petHospital[0].result.results[i].Hname)
                        self.hospitalAddr.append(self.petHospital[0].result.results[i].addr)
                        self.hospitalPhone.append(self.petHospital[0].result.results[i].phone)
                    }
                    DispatchQueue.main.async {
                        self.hospitalTableView.reloadData()
                        KRProgressHUD.dismiss()
                    }
                } catch {
                    print("jsDecoder Fail\(error)")
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    self.showAlert()
                }
            }
        }.resume()
    }
    
    // MARK: -- SearchContent
    func filterContent(for searchText: String) {
        searchDownload = petHospital[0].result.results.filter { (results) -> Bool in
            let isMatch = results.addr.localizedCaseInsensitiveContains(searchText)
            print("isMatch\(isMatch)")
            return isMatch
        }
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchHospitalController.isActive {
            print("搜尋後\(searchDownload.count)")
            return searchDownload.count
        } else {
            print("搜尋前\(chinesePetHospital.count)")
            return chinesePetHospital.count
        }
        //        print("Reload: \(chinesePetHospital.count)")
        //        return chinesePetHospital.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hospitalCell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath) as! HospitalTableViewCell
        searchHospitalController.obscuresBackgroundDuringPresentation = false
        
        if searchHospitalController.isActive {
            hospitalCell.hospitalName.text = "\(searchDownload[indexPath.row].Hname)"
            
            if indexPath.row > 9 {
                let index = indexPath.row % 10
                hospitalCell.hospitalImageView.image = UIImage(named: hospitalImages[index])
            } else {
                hospitalCell.hospitalImageView.image = UIImage(named: hospitalImages[indexPath.row])
            }
            
            hospitalCell.hospitalAddress.text = "\(searchDownload[indexPath.row].addr)"
            hospitalCell.hospitalPhoneNumber.text = "\(searchDownload[indexPath.row].phone)"
            return hospitalCell
        } else {
            hospitalCell.hospitalName.text = chinesePetHospital[indexPath.row]
            
            if indexPath.row > 9 {
                let index = indexPath.row % 10
                hospitalCell.hospitalImageView.image = UIImage(named: hospitalImages[index])
            } else {
                hospitalCell.hospitalImageView.image = UIImage(named: hospitalImages[indexPath.row])
            }
            
            hospitalCell.hospitalAddress.text = hospitalAddr[indexPath.row]
            hospitalCell.hospitalPhoneNumber.text = hospitalPhone[indexPath.row]
            return hospitalCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hospitalTableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "通話", style: .default, handler: { (action) in
            if let phoneURL = URL(string: ("tel://02\(self.hospitalPhone[indexPath.row])")) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("Fail to call.")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "導航", style: .default, handler: { (action) in
            self.geocoder.geocodeAddressString(self.hospitalAddr[indexPath.row]) { (placemarks, error) in
                guard error == nil else {
                    print("/Geocode failed with error: \(error.debugDescription)")
                    return
                }
                
                guard let placemarks = placemarks, placemarks.count > 0 else {
                    return
                }
                
                let targetPlaceMark = placemarks[0]
                let targetPlace = MKPlacemark(placemark: targetPlaceMark)
                let targetMapItem = MKMapItem(placemark: targetPlace)
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                targetMapItem.openInMaps(launchOptions: options)
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            self.hospitalTableView.reloadData()
        }
    }
}
