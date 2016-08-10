//
//  TableViewController.swift
//  GOfinder
//
//  Created by Ananth Christy on 7/20/16.
//  Copyright © 2016 christonan. All rights reserved.
//

import UIKit
import CoreData


//
//enum MapOptionsType: Int {
//    case MapBoundary = 0
//    case MapOverlay
//    case MapPins
//    case MapCharacterLocation
//    case MapRoute
//}


class TableViewController: UITableViewController {
    
//    var selectedOptions = [MapOptionsType]()
    let moc = DataController().managedObjectContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Table View worked")
        
        
        
//        if places.count == 0 /*&& places[0]["pokemon"] != "" */{
//            //let pokemonfetch = NSFetchRequest(entityName: "Pokemons")
//            do {
//                //var fetchedPokemon = try moc.executeFetchRequest(pokemonfetch) as! [Pokemons]
//                
//                //fetchedPokemon.removeAtIndex(0)
//                
//                let entity = NSEntityDescription.insertNewObjectForEntityForName("Pokemons", inManagedObjectContext:self.moc) as! Pokemons
//                entity.setValue("Pikachu", forKey: "name")
//                entity.setValue("NPU", forKey: "desc")
//                entity.setValue("37.477698", forKey: "lat")
//                entity.setValue("-121.925396", forKey: "long")
//                
//            } catch {
//                fatalError("Error at table view:\(error)")
//            }
//            
//            //places.append(["pokemon":"Pikachu","address": "NPU","lat":"37.477698","long":"-121.925396"])
//        }
//        
       
        
        
//        var recalledpokemons = NSUserDefaults.standardUserDefaults().objectForKey("pokemons")! as! NSArray
//        var recalledaddresses = NSUserDefaults.standardUserDefaults().objectForKey("addresses")! as! NSArray
//        var recalledlats = NSUserDefaults.standardUserDefaults().objectForKey("lats")! as! NSArray
//        var recalledlongs = NSUserDefaults.standardUserDefaults().objectForKey("longs")! as! NSArray
//        
//        for i in 1...recalledpokemons.count {
//            
//            
//        places.append(["pokemon":recalledpokemons[i] as! String,"address":recalledaddresses[i] as! String,"lat":recalledlats[i] as! String,"long":recalledlongs[i] as! String])
//        }
        

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var howmany = 0
        
        let pokemonfetch = NSFetchRequest(entityName: "Pokemons")
        do {
            let fetchedPokemon = try moc.executeFetchRequest(pokemonfetch) as! [Pokemons]
            howmany = fetchedPokemon.count
            
            //cell.textLabel?.text = fetchedPokemon[indexPath.row].name
        } catch {
            fatalError("Error at table view:\(error)")
        }

        return howmany
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlace = indexPath.row
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlace" {
            activePlace = -1
        }
    }
//    func deleteAllData(entity: String)
//    {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: entity)
//        fetchRequest.returnsObjectsAsFaults = false
//        
//        do
//        {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                managedContext.deleteObject(managedObjectData)
//            }
//        } catch let error as NSError {
//            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
//        }
//    }
    

     

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let pokemonfetch = NSFetchRequest(entityName: "Pokemons")
        do {
            let fetchedPokemon = try moc.executeFetchRequest(pokemonfetch) as! [Pokemons]
            
            cell.textLabel?.text = fetchedPokemon[indexPath.row].name
        } catch {
            fatalError("Error at table view:\(error)")
        }
//
//        let mapOptionsType = MapOptionsType(rawValue: indexPath.row)
//        switch (mapOptionsType!) {
//        case .MapBoundary:
//            cell.textLabel!.text = "Park Boundary"
//        case .MapOverlay:
//            cell.textLabel!.text = "Map Overlay"
//        case .MapPins:
//            cell.textLabel!.text = "Attraction Pins"
//        case .MapCharacterLocation:
//            cell.textLabel!.text = "Character Location"
//        case .MapRoute:
//            cell.textLabel!.text = "Route"
//        }
//        
//        if selectedOptions.contains(mapOptionsType!) {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//        }


        // Configure the cell...

        return cell
    }

    /*
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let mapOptionsType = MapOptionsType(rawValue: indexPath.row)
        if (cell!.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            // delete object
            selectedOptions = selectedOptions.filter { (currentOption) in currentOption != mapOptionsType}
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedOptions += [mapOptionsType!]
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
