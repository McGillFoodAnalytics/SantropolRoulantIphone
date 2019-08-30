//
//  ContactPage.swift
//  Santrapol_UA
//
//  Created by Guillaume on 8/8/19.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import MapKit

class ContactPage: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let regionRadius: CLLocationDistance = 500
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        let initialLocation = CLLocation(latitude: 45.516520, longitude: -73.575146)
        
        mapView.delegate = self as? MKMapViewDelegate
        
        let artwork = Artwork(title: "Santropol Roulant",
            locationName: "Social services organization",
            discipline: "Montreal", coordinate: CLLocationCoordinate2D(latitude: 45.516520, longitude: -73.575146))
        
        mapView.addAnnotation(artwork)

        
        centerMapOnLocation(location: initialLocation)


    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ContactPage: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        //    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
            view.rightCalloutAccessoryView = mapsButton
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }}
