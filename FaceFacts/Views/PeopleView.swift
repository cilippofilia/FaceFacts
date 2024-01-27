//
//  PeopleView.swift
//  FaceFacts
//
//  Created by Filippo Cilia on 27/01/2024.
//

import SwiftData
import SwiftUI

struct PeopleView: View {
    /// The SwiftData model context that will be used for queries and other
    /// model operations within this environment.
    @Environment(\.modelContext) var modelContext

    /// SwiftData provides the @Query macro for querying model objects from a SwiftUI view, optionally providing a sort order, a filter predicate,
    /// and either a custom animation or a custom transaction to handle changing results smoothly.
    /// Even better, @Query automatically stays up to date every time your data changes, and will reinvoke your SwiftUI view so it stays in sync.
    @Query var people: [Person]

    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink(value: person) {
                    Text(person.name)
                }
            }
            .onDelete(perform: deletePeople)
        }
    }
    
    /// Initializes a ViewModel for managing a list of people with search functionality and custom sorting.
    ///
    /// - Parameters:
    ///    - searchString: A string used for searching people. If empty, all people are considered.
    ///    - sortOrder: An array of `SortDescriptor` specifying the sorting order for the list.
    ///
    /// The ViewModel is backed by a `Query` that applies a filter and sorting to the list of people based on the provided parameters.
    ///
    /// - Important:
    ///    The filter criteria include checking if the person's name, email address, or details contain the `searchString`.
    ///    The search is case-insensitive and uses `localizedStandardContains` for more accurate matching.
    ///
    /// - Note:
    ///    To use this ViewModel, access the `people` property to get the filtered and sorted list of people.
    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        _people = Query(filter: #Predicate { person in
            if searchString.isEmpty {
                true
            } else {
                person.name.localizedStandardContains(searchString)
                || person.emailAddress.localizedStandardContains(searchString)
                || person.details.localizedStandardContains(searchString)

            }
        }, sort: sortOrder)
    }
    
    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return PeopleView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
