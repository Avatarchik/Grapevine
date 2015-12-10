//
//  DraggableViewBackground.swift
//  Grapevine
//
//  Referenced from TinderSwipeCardsSwift created by Gao Chao
//  https://github.com/reterVision/TinderSwipeCardsSwift
//
//  Created by Jenny Yang on 12/6/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class DraggableViewBackground: UIView, DraggableViewDelegate {
    
    var eventsArray: [Event] = [Event]()
    var allCards: [DraggableView]!
    
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 492
    let CARD_WIDTH: CGFloat = 370
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    
    var eventDateFormatter = NSDateFormatter()
    var eventTimeFormatter = NSDateFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        
        eventDateFormatter.dateFormat = "MMMM d"
        eventTimeFormatter.dateFormat = "h:mma"
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        getAllEvents()
//        self.loadCards()
    }
    
    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        
        xButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 100, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        xButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)
        
        checkButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 160, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
        checkButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(xButton)
        self.addSubview(checkButton)
    }
    
    func getAllEvents() {
        let query = PFQuery(className:"Event")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let newEvent = Event()
                        newEvent.objectID = object.objectId!
                        newEvent.eventName = object["EventName"] as? String
                        newEvent.start = object["start"] as? NSDate
                        newEvent.location = object["location"] as? String                        
                        let imageFile = object["eventPhoto"] as! PFFile
                        imageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    let image = UIImage(data:imageData)
                                    newEvent.eventPhoto = image!
                                }
                            }
                        }
                        self.eventsArray.append(newEvent)
                    }
                }
                // Calling loadCards() here even though it should be called in init()
                // this is because finding objects through a Parse query will not properly add objects to an array
                self.loadCards()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT))
//        print("before", eventsArray[index].eventPhoto)
        draggableView.eventName.text = eventsArray[index].eventName
        draggableView.eventDate.text = eventDateFormatter.stringFromDate(eventsArray[index].start!)
        draggableView.eventStart.text = eventTimeFormatter.stringFromDate(eventsArray[index].start!).lowercaseString
        draggableView.eventPhotoView.sizeToFit()
        draggableView.eventPhotoView.image = eventsArray[index].eventPhoto
//        print(draggableView.eventPhotoView.image)
        draggableView.delegate = self
        return draggableView
    }
    
    func loadCards() -> Void {
        if eventsArray.count > 0 {
            let numLoadedCardsCap = eventsArray.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : eventsArray.count
            for var i = 0; i < eventsArray.count; i++ {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
//                print("loadCards function here:", newCard.eventPhotoView)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for var i = 0; i < loadedCards.count; i++ {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}