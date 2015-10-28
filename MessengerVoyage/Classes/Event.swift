//
//  Event.swift
//  MessengerVoyage
//
//  Created by Iker on 27/10/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit


class Event: NSObject, NSCoding {
    private var eventTitle: String?
    private var eventText: String?
    private var eventOptA: String?
    private var eventOptB: String?
    private var eventOptC: String?
    private var eventOptD: String?
    private var eventNature: Bool?
    private var eventTree: [Event] = []
    // TRUE = positiva, FALSE = negative
    
    required init?(coder aDecoder: NSCoder) {
        self.eventTitle = aDecoder.decodeObjectForKey("Title") as? String
        self.eventText = aDecoder.decodeObjectForKey("Text") as? String
        self.eventOptA = aDecoder.decodeObjectForKey("OptionA") as? String
        self.eventOptB = aDecoder.decodeObjectForKey("OptionB") as? String
        self.eventOptC = aDecoder.decodeObjectForKey("OptionC") as? String
        self.eventOptD = aDecoder.decodeObjectForKey("OptionD") as? String
        self.eventNature = aDecoder.decodeBoolForKey("Nature")
    }
    
    init(with title: String, text: String, optA: String, optB: String, optC: String, optD: String, and nature: Bool) {
        super.init()
        self.eventTitle = title
        self.eventText = text
        self.eventOptA = optA
        self.eventOptB = optB
        self.eventOptC = optC
        self.eventOptD = optD
        self.eventNature = nature
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
    func getEventInformation() -> NSDictionary {
        let info: NSDictionary = NSDictionary(objects: [self.eventTitle!, self.eventText!, self.eventOptA!, self.eventOptB!, self.eventOptC!, self.eventOptD!, self.eventNature!], forKeys: ["eventTitle", "eventText", "eventOptA", "eventOptB", "eventOptC", "eventOptD", "eventNature"])
        return info
    }
}
