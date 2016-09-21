//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Brian McDevitt on 7/13/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    let spacing = 5
    let startCount = 5
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<startCount {
            let button = UIButton()
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            button.adjustsImageWhenDisabled = false
            //button.showsTouchWhenHighlighted = false
            button.addTarget(self, action: #selector(RatingControl.ratingButtonPressed(_:)), forControlEvents: .TouchDown)
            ratingButtons.append(button)
            addSubview(button)
        }
        
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * startCount
        
        return CGSize(width: width, height: buttonSize)
    }
    
    override func layoutSubviews() {
        
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        
        updateButtonSelctionStates()
    }
    
    func ratingButtonPressed(button: UIButton) {
        if ratingButtons.indexOf(button)! == rating - 1 {
            rating = 0
        } else {
            rating = ratingButtons.indexOf(button)! + 1
        }
        
        updateButtonSelctionStates()
    }
    
    func updateButtonSelctionStates() {
        for (index, button) in ratingButtons.enumerate() {
            button.selected = index < rating
        }
    }
}