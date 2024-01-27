//
//  Previewer.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let event: Event
    let person: Person
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)

        event = Event(name: "Imbibe Live", location: "London, UK")
        person = Person(name: "Tony Alvarez", emailAddress: "tony.alvarez@email.com", details: "", metAt: event)
        
        container.mainContext.insert(person)
    }
}
