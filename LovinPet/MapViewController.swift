//
//  MapViewController.swift
//  LovinPet
//
//  Created by Jeffery on 2022/5/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    //MARK: - View
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        
    }
    
    //MARK: - SettingUI
    func setLocationManager() {
        // 設置委任對象
        locationManager.delegate = self
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func configureUI() {
        view.addSubview(containerView)
        
    }
    
}

//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
}
