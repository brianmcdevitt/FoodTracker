//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Brian McDevitt on 7/13/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    var mealStore: MealStore!
    var imageStore: ImageStore!
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealStore.allMeals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MealCell") as! MealCell
        
        let meal = mealStore.allMeals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.mealImageView.image = imageStore.imageForKey(meal.mealKey)
        cell.ratingControl.rating = meal.rating
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let meal = mealStore.allMeals[indexPath.row]
            
            let title = "Delete \(meal.name)"
            let message = "Are you sure you want to delete this meal?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                
                self.mealStore.removeMeal(meal)
                self.imageStore.deleteImageForKey(meal.mealKey)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            })
            ac.addAction(deleteAction)
            
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mealStore.allMeals.isEmpty {
            loadSampleMeals()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMeal" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let meal = mealStore.allMeals[row]
                let viewController = segue.destinationViewController as! DetailViewController
                viewController.meal = meal
                viewController.imageStore = imageStore
            }
            
        } else if segue.identifier == "AddMeal" {
            let navViewController = segue.destinationViewController as! UINavigationController
            let viewController = navViewController.topViewController as! DetailViewController
            viewController.imageStore = imageStore
            viewController.meal = Meal(name: "", rating: 0)
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetailViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                mealStore.allMeals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                //Create a new item and add it to the store
                let newMeal = mealStore.addMeal(meal)
                
                //Figure out where that item is in the array
                if let index = mealStore.allMeals.indexOf(newMeal) {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    
                    //Insert this new row into the table
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    func loadSampleMeals() {
        mealStore.createMeal("Pasta with Meatballs", rating: 4)
        mealStore.createMeal("Caprese Salad", rating: 2)
        mealStore.createMeal("Chicken and Potatoes", rating: 5)
        imageStore.setImage(UIImage(named: "mealImage1")!, forKey: mealStore.allMeals[0].mealKey)
        imageStore.setImage(UIImage(named: "mealImage2")!, forKey: mealStore.allMeals[1].mealKey)
        imageStore.setImage(UIImage(named: "mealImage3")!, forKey: mealStore.allMeals[2].mealKey)
    }
    
}
