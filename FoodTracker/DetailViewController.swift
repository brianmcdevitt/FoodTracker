//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Brian McDevitt on 7/13/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var meal: Meal!
    var imageStore: ImageStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        nameTextField.text = meal.name
        ratingControl.rating = meal.rating
        
        let imageKey = meal.mealKey
        if let image = imageStore.imageForKey(imageKey) {
            imageView.image = image
        } else {
            //imageView.image = UIImage(named: "defaultImage")
        }
        
        navigationItem.title = nameTextField.text
        
        checkValidName()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        //saveMealChanges()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            if let image = imageView.image {
                imageStore.setImage(image, forKey: meal.mealKey)
            }
            let rating = ratingControl.rating
            
            meal.name = name
            meal.rating = rating
        }
    }
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backgroundTapped(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidName()
        navigationItem.title = nameTextField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    func saveMealChanges() {
        meal.name = nameTextField.text ?? ""
        meal.rating = ratingControl.rating
    }
    
    func checkValidName() {
        let name = nameTextField.text ?? ""
        saveButton.enabled = !name.isEmpty
    }
    
}
