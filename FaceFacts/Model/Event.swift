//
//  Event.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String = ""
    var location: String = ""
    var people: [Person]? = [Person]()
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
