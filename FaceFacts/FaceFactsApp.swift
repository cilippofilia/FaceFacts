//
//  FaceFactsApp.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import SwiftData
import SwiftUI

/// Set the model container in this scene for storing the provided
/// model type, creating a new container if necessary, and also sets a model
/// context for that container in this scene's environment.
///
/// In this example, `FaceFacts` sets a shared model container to use for
/// all of its windows, configured to store instances of `Person`.
///
/// It can also store different instances by placing them inside an array.
/// .modelContainer(for: [Recipe.self, Ingredient.self])


@main
struct FaceFactsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
