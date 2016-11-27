//
//  SweetMemory.swift
//  Sweet Memories
//
//  Created by Mac air on 11/27/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import Foundation
import CoreData

class SweetMemory:NSManagedObject {
    @NSManaged var title:String
    @NSManaged var note:String
    @NSManaged var image:NSData?
    @NSManaged var rating:String?
    @NSManaged var date:NSDate
}

//class Restaurant {
//    var name = ""
//    var type = ""
//    var location = ""
//    var image = ""
//    var isVisited = false
//    init(name:String, type:String, location:String, image:String,
//         isVisited:Bool) {
//        self.name = name
//        self.type = type
//        self.location = location
//        self.image = image
//        self.isVisited = isVisited
//    }
//}