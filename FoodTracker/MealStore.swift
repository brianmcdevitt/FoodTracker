//
//  MealStore.swift
//  FoodTracker
//
//  Created by Brian McDevitt on 7/13/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class MealStore {
    
    var allMeals = [Meal]()
    let mealArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("meals.archive")
    }()
    
    init() {
        if let archivedMeals = NSKeyedUnarchiver.unarchiveObjectWithFile(mealArchiveURL.path!) as? [Meal] {
            allMeals += archivedMeals
        }
    }
    
    func createMeal(name: String, rating: Int) -> Meal {
        let meal = Meal(name: name, rating: rating)
        
        allMeals.append(meal)
        
        return meal
    }
    
    func removeMeal(meal: Meal) {
        if let index = allMeals.indexOf(meal) {
            allMeals.removeAtIndex(index)
        }
    }
    
    func addMeal(meal: Meal) -> Meal {
        allMeals.append(meal)
        return meal
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(mealArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allMeals, toFile: mealArchiveURL.path!)
    }
}
