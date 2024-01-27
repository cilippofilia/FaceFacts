//
//  FaceFactsApp.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import SwiftData
import SwiftUI

@main
struct FaceFactsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
