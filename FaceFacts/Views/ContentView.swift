//
//  ContentView.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    /// The SwiftData model context that will be used for queries and other
    /// model operations within this environment.
    @Environment(\.modelContext) var modelContext
    
    /// A serializable description of how to sort numeric and `String` types.
    @State private var sortOrder = [SortDescriptor(\Person.name)]
    @State private var path = NavigationPath()
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("FaceFacts")
            
                /// Associates a destination view with a presented data type for use within a navigation stack.
                /// Add this view modifier to a view inside a `NavigationStack` to describe the view that the stack displays when presenting a particular kind of data.
                .navigationDestination(for: Person.self) { person in
                    
                    /// Use a `NavigationLink` to present the data.
                    EditPersonView(person: person, navigationPath: $path)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)").tag([SortDescriptor(\Person.name)])
                            Text("Name (Z-A)").tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }
                    Button("Add Person", systemImage: "plus", action: addPerson)
                }
                .searchable(text: $searchText)
        }
    }
    
    func addPerson() {
        let person = Person(name: "", emailAddress: "", details: "") /// Create a new instance of a Person
        modelContext.insert(person) /// Tell `SwiftData` to store this person
        path.append(person) /// Append this to our navigation path in order to let the `NavigationStack` which view to display
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
