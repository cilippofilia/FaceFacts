//
//  EditPersonView.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import PhotosUI
import SwiftData
import SwiftUI

struct EditPersonView: View {
    @Bindable var person: Person
    @Binding var navigationPath: NavigationPath
    
    /// The SwiftData model context that will be used for queries and other
    /// model operations within this environment.
    @Environment(\.modelContext) var modelContext
    
    @State private var selectedItem: PhotosPickerItem?
    
    /// Property wrapper for managing a list of `Event` instances with sorting.
    /// The `@Query` property wrapper is used to define a sorted list of `Event` instances.
    ///    The sorting is based on the provided `SortDescriptor` instances, which specify the sorting criteria for the `name` and `location` properties of each `Event`.
    ///
    /// - Important:
    /// The `events` property provides access to the sorted list of `Event` instances.
    /// The sorting order is determined by the `SortDescriptor` instances, with the primary sort on `Event.name` and the secondary sort on `Event.location`.
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)
    ]) var events: [Event]

    var body: some View {
        Form {
            Section {
                if let imageData = person.photo,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person.fill")
                }
            }
            
            Section {
                TextField("Name", text: $person.name)
                    .textContentType(.name)
                
                TextField("Email Address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Where did you meet them?") {
                Picker("Met at", selection: $person.metAt) {
                    Text("Unknown event")
                        .tag(Optional<Event>.none)
                    
                    if events.isEmpty == false {
                        Divider()
                        ForEach(events) { event in
                            Text(event.name)
                                .tag(Optional(event))
                        }
                    }
                }
                
                Button("Add new event", action: addEvent)
            }
            
            Section("Notes") {
                TextField("Details about \(person.name)", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
        .onChange(of: selectedItem, loadPhoto)
    }
    
    func addEvent() {
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        navigationPath.append(event)
    }
    
    func loadPhoto() {
        Task {
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EditPersonView(person: previewer.person, navigationPath: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
