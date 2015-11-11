//
//  SupportCharactersHandler.swift
//  UltraDelivery
//
//  Created by Iker on 10/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class SupportCharactersHandler: NSObject {
    private var characters: [SupportCharacters]!
    
    init(selectedCharacters: NSDictionary) {
        super.init()
        for selectedCh in selectedCharacters {
            characters.append(selectedCh as! SupportCharacters)
        }
    }
}
