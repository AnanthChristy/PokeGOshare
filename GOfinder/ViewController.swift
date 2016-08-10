//
//  ViewController.swift
//  GOfinder
//
//  Created by Ananth Christy on 7/20/16.
//  Copyright © 2016 christonan. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import CoreData


var places = [Dictionary<String,String>()]
var activePlace = -1

enum MapType: Int {
    case Standard = 0
    case Hybrid
    case Satellite
}

var rowCounter:Int = 0
 //let moc = DataController().managedObjectContext



class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

//    var pokemons: [NSString] = []
//    var addresses: [NSString] = []
//    var lats: [NSString] = []
//    var longs: [NSString] = []
    
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let moc = DataController().managedObjectContext
    
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locaName = NSString()
    
    @IBAction func share(sender:AnyObject){
        
        //custom class to send location over message
        let loca = locationVCardURLFromCoordinate(center,name: locaName)
        
        //alternate to class to send location as a link
        //let newURL = "http://maps.apple.com/?ll=\(center.latitude),\(center.longitude)"
        
        
        let vc = UIActivityViewController(activityItems: [loca!], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    
//    let firstTextField = alertController.textFields![0] as UITextField
//    let secondTextField = alertController.textFields![1] as UITextField
    
    let locationManager = CLLocationManager()
//    var selectedOptions = [MapOptionsType]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareTapped))
        
        
        
        print(rowCounter)
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        } else {
            
            fetchPokemons()
            


        }
    
        
        let gestrecon = UILongPressGestureRecognizer(target: self, action: "action:" )
        gestrecon.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gestrecon)
        
    }
    
    func fetchPokemons() {
        let pokemonfetch = NSFetchRequest(entityName: "Pokemons")
        
        do {
            let fetchedPokemon = try moc.executeFetchRequest(pokemonfetch) as! [Pokemons]
            let latitude = NSString(string:fetchedPokemon[activePlace].lat!).doubleValue
            let longitude  = NSString(string:fetchedPokemon[activePlace].long!).doubleValue
//            let longitude = NSString(string:places[activePlace]["long"]!).doubleValue
            center = CLLocationCoordinate2D(latitude: latitude, longitude:  longitude)
            
            let region = MKCoordinateRegion(center: center,span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()
            
            
            let annotation  = MKPointAnnotation()
            annotation.coordinate = center
            
            locaName = NSString(string:fetchedPokemon[activePlace].name!)
            
            annotation.title = fetchedPokemon[activePlace].name
            annotation.subtitle = fetchedPokemon[activePlace].desc
            self.mapView.addAnnotation(annotation)
            
            
            
//            func shareTapped() {
//                let loca = locationVCardURLFromCoordinate(center)
//                let vc = UIActivityViewController(activityItems: [loca!], applicationActivities: [])
//                vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//                presentViewController(vc, animated: true, completion: nil)
//            }
            

            
//            let counter = fetchedPokemon.count
//            
//            for counter in fetchedPokemon {
//                
//            }

            
            
        } catch {
            fatalError("Error in retreiving data: \(error)")
        }

    }
    
    func action(gestureRecognizer : UIGestureRecognizer) {
        print("Gesture Recognized")
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            
            let newcoordinates: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            var location = CLLocation(latitude: newcoordinates.latitude, longitude: newcoordinates.longitude)
            var descr = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks , error) -> Void in
                
                if(error == nil) {
                    if let p = placemarks?.first {
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!
                        }
                        
                        descr = "\(subThoroughfare) \(thoroughfare)"
                    }
                    
                }
                
                if descr == "" {
                    descr = "Added \(NSDate())"
                }
                
                
                
                var annotation  = MKPointAnnotation()
                annotation.coordinate = newcoordinates
                var tField: UITextField!
              
                func configurationTextField(textField: UITextField!)
                {
                    print("generating the TextField")
                    textField.placeholder = "Pokemon name"
                    //textField.font?.fontWithSize(20.0)
                    textField.minimumFontSize = 28.0
                    textField.textAlignment = NSTextAlignment.Center
                    tField = textField
                    
                    
                    
                }
                
                func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
                    // Don't want to show a custom image if the annotation is the user's location.
                    guard !annotation.isKindOfClass(MKUserLocation) else {
                        return nil
                    }
                    
                    let annotationIdentifier = "AnnotationIdentifier"
                    
                    var annotationView: MKAnnotationView?
                    if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
                        annotationView = dequeuedAnnotationView
                        annotationView?.annotation = annotation
                    }
                    else {
                        let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                        av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                        annotationView = av
                    }
                    
                    if let annotationView = annotationView {
                        // Configure your annotation view here
                        annotationView.canShowCallout = true
                        annotationView.image = UIImage(named: "pokes")
                    }
                    
                    return annotationView
                }
                
//                
//                func mapView(mapView: MKMapView!,
//                    viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//                    if (annotation is MKUserLocation) { return nil }
//                    
//                    let reuseID = "chest"
//                    var v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
//                    
//                    if v != nil {
//                        v!.annotation = annotation
//                    } else {
//                        v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
//                        
//                        v!.image = UIImage(named:"pokes")
//                    }
//                    
//                    return v
//                }
                
                
                
                func handleCancel(alertView: UIAlertAction!)
                {
                    print("Cancelled !!")
                }
                
                let alert = UIAlertController(title: "Watcha catch?", message: "Gotta share em' all!", preferredStyle: .Alert)
                
                alert.addTextFieldWithConfigurationHandler(configurationTextField)
     
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
                    print("Done !!")
                    
                    print("Item : \(tField.text)")
                    
                    let pokemon = tField.text?.localizedCapitalizedString
                    annotation.title = pokemon
                    annotation.subtitle = descr
              
                    
                    
                    //Adding to dictionary
                    places.append(["pokemon":pokemon!,"address":descr,"lat":"\(newcoordinates.latitude)","long":"\(newcoordinates.longitude)"] )
                    
                    //Adding to Core Data
                    func seedPokemon() {
                        
                        
                        let entity = NSEntityDescription.insertNewObjectForEntityForName("Pokemons", inManagedObjectContext:self.moc) as! Pokemons
                        
                        entity.setValue(pokemon, forKey: "name")
                        entity.setValue(descr, forKey: "desc")
                        entity.setValue("\(newcoordinates.latitude)", forKey: "lat")
                        entity.setValue("\(newcoordinates.longitude)", forKey: "long")
                        
                        do {
                            try self.moc.save()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                        
                    }
                    
                    seedPokemon()
                    
                    
                    
                    
                    //Adding to database
//                    var counter = 0
//                    self.pokemons[counter] = (tField.text?.localizedCapitalizedString)!
//                    self.addresses[counter] = descr
//                    
//                    //converting coordinates to string
//                    self.lats[counter] = "\(newcoordinates.latitude)"
//                    self.longs[counter] = "\(newcoordinates.longitude)"
//                    NSUserDefaults.standardUserDefaults().setObject(self.pokemons, forKey: "pokemons")
//                    NSUserDefaults.standardUserDefaults().setObject(self.pokemons, forKey: "pokemons")
//                    NSUserDefaults.standardUserDefaults().setObject(self.pokemons, forKey: "pokemons")
//                    NSUserDefaults.standardUserDefaults().setObject(self.pokemons, forKey: "pokemons")
                    //mapView.delegate = self
                    //annotaion finally added, Phew!!
                    annotation.title = pokemon
                    annotation.subtitle = descr
                    //self.mapView.addAnnotation(annotation)
                    mapView(self.mapView, viewForAnnotation: annotation)!.annotation = annotation
                    self.mapView.addAnnotation(annotation)
//                    counter++
                }))
                
                
                self.presentViewController(alert, animated: true, completion: {
                    print("completion block")
                })
                
                
            })

            
           
            
        }
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    

    @IBAction func mapTypeChanged(sender: AnyObject) {
        let mapType = MapType(rawValue: mapTypeSegmentedControl.selectedSegmentIndex)
        switch (mapType!) {
        case .Standard:
            mapView.mapType = MKMapType.Standard
        case .Hybrid:
            mapView.mapType = MKMapType.Hybrid
        case .Satellite:
            mapView.mapType = MKMapType.Satellite
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude:  location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center,span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Errors" + error.localizedDescription)
    }
    
    



}

