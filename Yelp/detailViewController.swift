//
//  detailViewController.swift
//  Yelp
//
//  Created by 吕凌晟 on 16/2/10.
//  Copyright © 2016年 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class detailViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var ResPhoto: UIImageView!
    @IBOutlet weak var ResName: UILabel!
    
    @IBOutlet weak var rightCard: UIView!
    @IBOutlet weak var ResCate: UILabel!
    @IBOutlet weak var openState: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bottonCard: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    var business: Business!
    var locationManager : CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottonCard.layer.cornerRadius=6
        bottonCard.layer.masksToBounds=true
        ResPhoto.layer.cornerRadius=8
        ResPhoto.layer.masksToBounds=true
        bottonCard.layer.borderColor = UIColor.grayColor().CGColor
        bottonCard.layer.borderWidth = 4;
        rightCard.layer.cornerRadius=6
        rightCard.layer.masksToBounds=true
        self.navigationItem.title=business.name
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        ResPhoto.setImageWithURL(business.imageURL!)
        ResName.text=business.name
        ResCate.text=business.categories
        addressLabel.text=business.address
        if business.isClosed==true{
            openState.text="Closed"
        }else{
            openState.text="Open"
        }
        
        
        
        mapView.delegate=self
        let centerLocation = CLLocation(latitude: business.coordinate.0!, longitude: business.coordinate.1!)
        goToLocation(centerLocation)
        
        addPin(latitude: (business?.coordinate.0)!, longitude: (business?.coordinate.1)!, title: business!.name! )
        
        
        
        
        let attributes =  [NSForegroundColorAttributeName: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 1.0),
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 20.0)!]
        self.navigationController?.navigationBar.titleTextAttributes=attributes
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func addPin(latitude latitude: Double, longitude: Double, title: String) {
        
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = locationCoordinate
        annotation.title = title
        
        mapView.addAnnotation(annotation)
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "An annotation!"
        mapView.addAnnotation(annotation)
    }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
