//
//  ContentView.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var sortOrder = [SortDescriptor(\Person.name)]
    @State private var path = NavigationPath()
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("FaceFacts")
                .navigationDestination(for: Person.self) { person in
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
        let person = Person(name: "", emailAddress: "", details: "") // create a new instance of a person
        modelContext.insert(person) // tell swiftData to store this person
        path.append(person) // navigate to this
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
