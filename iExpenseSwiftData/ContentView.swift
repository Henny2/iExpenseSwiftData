//
//  ContentView.swift
//  iExpenseSwiftData
//
//  Created by Henrieke Baunack on 12/19/23.
//

import SwiftUI
import SwiftData
// protocol Identifiable
@Model
class ExpenseItem {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}

// https://www.hackingwithswift.com/quick-start/swiftdata/sorting-query-results
// explains that you need to create a subview to change parameters of the query
 
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State var sortOrder = [SortDescriptor(\ExpenseItem.name)]
    @State private var showingAddExpense = false
    @State private var searchString = ""
    var body: some View {
        NavigationStack{
            ExpesnseListView(filter: searchString, sort: sortOrder)
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add expense", systemImage: "plus"){
                        showingAddExpense = true
                    }
                    Menu("Filter", systemImage: "arrow.up.arrow.down"){
                        Picker("Pick filter", selection: $sortOrder){
                            Text("By Name")
                                .tag([SortDescriptor(\ExpenseItem.name)])
                            Text("By Amount")
                                .tag([SortDescriptor(\ExpenseItem.amount)])
                            
                        }
                    }

                }
                .searchable(text: $searchString)
                .sheet(isPresented: $showingAddExpense, content: {
                    AddView()
                })
        }
    }

    

}

#Preview {
    ContentView(sortOrder: [SortDescriptor(\ExpenseItem.name)])
}
