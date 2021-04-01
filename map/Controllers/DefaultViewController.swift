//
//  ViewController.swift
//  map
//
//  Created by USER on 2021/01/19.
import UIKit
import NMapsMap

class DefaultViewController: UIViewController, DefaultViewControllerDelegate, CLLocationManagerDelegate {

    private var customTabBarController: TabBarController?
    private var markers: [NMFMarker] = [NMFMarker]()
    private let naverMapView: NMFNaverMapView = NMFNaverMapView(frame: .zero)
    private let locationManager = CLLocationManager()
    private var smartAroundViewController: SmartAroundViewController?
    private let moveToBusanButton = UIButton(frame: CGRect(x: 10, y: 50, width: 80, height: 40))
    private let searchCafeButton = UIButton(frame: CGRect(x: 100, y: 50, width: 80, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        attachViews()
        mapViewStyling()
        buttonsStyling()
        setupDelegate()
        setForGestureRecognizer()
        naverMapView.frame = view.frame
        naverMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveToCurrentLocation()
        updateSmartAroundTabInfo()
    }

    private func moveToCurrentLocation() {
        var currentLat: Double
        var currentLng: Double
        locationManager.requestWhenInUseAuthorization()

        currentLat = getCurrentLocation().lat
        currentLng = getCurrentLocation().lng

        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLat, lng: currentLng))
        cameraUpdate.animation = .fly
        naverMapView.mapView.moveCamera(cameraUpdate)
    }

    private func getCurrentLocation() -> (lat: Double, lng: Double) {
        locationManager.requestWhenInUseAuthorization()

        if let coor = locationManager.location?.coordinate {
            return (coor.latitude, coor.longitude)
        } else {
            return (Setting.cityHallLat, Setting.cityHallLng)
        }
    }

    private func setupDelegate() {
        smartAroundViewController?.defaultViewControllerDelegate = self
        naverMapView.delegate = self
        locationManager.delegate = self
    }

    func updateSmartAroundTabInfo() {
        let lat = naverMapView.mapView.latitude
        let lng = naverMapView.mapView.longitude

        smartAroundViewController?.update(lat, lng, .all)
    }

    private func setForGestureRecognizer() {
        moveToBusanButton.addTarget(self, action: #selector(self.moveToBusanButtonClicked), for: .touchDown)
        searchCafeButton.addTarget(self, action: #selector(self.searchCafeButtonClicked), for: .touchDown)
    }

    private func attachViews() {
        naverMapView.frame = view.frame
        view.addSubview(naverMapView)
        view.addSubview(moveToBusanButton)
        view.addSubview(searchCafeButton)

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        customTabBarController = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? TabBarController
        guard let customTabBarController = customTabBarController, let tabBarView = customTabBarController.view else { return }
        addChild(customTabBarController)
        view.addSubview(tabBarView)

        guard let smartAroundViewController = customTabBarController.viewControllers?[safe: 0] as? SmartAroundViewController else { return }
        self.smartAroundViewController = smartAroundViewController
    }

    private func mapViewStyling() {
        naverMapView.showLocationButton = true
        naverMapView.positionMode = .direction
    }

    private func buttonsStyling() {
        moveToBusanButton.setTitle("부산역", for: .normal)
        moveToBusanButton.backgroundColor = .darkGray

        searchCafeButton.setTitle("카페", for: .normal)
        searchCafeButton.backgroundColor = .darkGray
    }

    func defaultViewControllerAddMarkers(for places: [Place]) {

        _ = markers.map({ $0.mapView = nil })

        for place in places {
            let marker: NMFMarker = NMFMarker()
            marker.position = NMGLatLng(lat: Double(place.y) ?? 0.0, lng: Double(place.x) ?? 0.0)
            marker.mapView = naverMapView.mapView
            marker.width = 30
            marker.height = 30
            marker.captionText = place.name
            marker.captionTextSize = 12
            markers.append(marker)
        }
    }

    func defaultViewControllerAnimateByScroll() {
        customTabBarController?.animateView(toSize: .mid)
    }

    @objc private func moveToBusanButtonClicked(_ sender: AnyObject?) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Setting.busanLat, lng: Setting.busanLng))
        cameraUpdate.animation = .fly
        naverMapView.mapView.moveCamera(cameraUpdate)

        customTabBarController?.animateView(toSize: .mid)
        updateSmartAroundTabInfo()
    }

    @objc private func searchCafeButtonClicked(_ sender: AnyObject?) {
        customTabBarController?.animateView(toSize: .mid)
    }
}

extension DefaultViewController: NMFMapViewDelegate {

    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        if CLLocationManager.authorizationStatus() == .denied {
            let locationAlertController = UIAlertController(title: nil, message: Setting.locationPermissionString, preferredStyle: .alert)

            let settingAction = UIAlertAction(title: "설정으로 이동", style: .default, handler: {_ in
                guard let settingString = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingString, options: [:], completionHandler: nil)
            })
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            locationAlertController.addAction(settingAction)
            locationAlertController.addAction(cancelAction)
            present(locationAlertController, animated: true, completion: nil)
        }
        customTabBarController?.animateView(toSize: .low)
    }
}
