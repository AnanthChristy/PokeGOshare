//
//  Pokemons+CoreDataProperties.swift
//  GOfinder
//
//  Created by Ananth Christy on 7/31/16.
//  Copyright © 2016 christonan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pokemons {

    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var lat: String?
    @NSManaged var long: String?

}
