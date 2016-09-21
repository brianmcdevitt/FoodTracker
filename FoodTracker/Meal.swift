//
//  Meal.swift
//  FoodTracker
//
//  Created by Brian McDevitt on 7/13/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {
    
    var name: String
    var rating: Int
    var mealKey: String
    
    init(name: String, rating: Int) {
        self.name = name
        self.rating = rating
        self.mealKey = NSUUID().UUIDString
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        mealKey = aDecoder.decodeObjectForKey("mealKey") as! String
        rating = aDecoder.decodeIntegerForKey("rating")
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(mealKey, forKey: "mealKey")
        aCoder.encodeInteger(rating, forKey: "rating")
    }
}
