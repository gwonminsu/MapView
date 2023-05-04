//
//  ViewController.swift
//  MapView
//
//  Created by 권민수 on 2023/05/04.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도에 관련된 초깃값들
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        // 델리게이트 self 설정
        locationManager.delegate = self
        // 정확도 최고수준으로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터 추적하기 위한 승인 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
        // 위치 보기 값을 true로 설정
        myMap.showsUserLocation = true
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
        })
        
        locationManager.stopUpdatingLocation()
    }
    
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }

    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latitudeValue: 35.912567, longitudeValue: 128.806164, delta: 1, title: "대구가톨릭대학교 효성캠퍼스", subtitle: "경상북도 경산시 하양읍 하양로 13-13")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "대구가톨릭대학교 효성캠퍼스"
        } else if sender.selectedSegmentIndex == 2 {
            setAnnotation(latitudeValue: 35.827400, longitudeValue: 128.744539, delta: 0.1, title: "남매지", subtitle: "경상북도 경산시 동부동 643")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "남매지"
        } else if sender.selectedSegmentIndex == 3 {
            setAnnotation(latitudeValue: 35.825015, longitudeValue: 128.732328, delta: 0.1, title: "우리집", subtitle: "경상북도 경산시 중방동 ")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "우리집"
        }
    }
    
}

