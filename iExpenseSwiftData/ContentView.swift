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
   
    
    //    @Query(
    //        filter: #Predicate<User> { user in
    //            user.name.localizedStandardContains("r") &&
    //            user.city == "Liverpool" },
    //        sort: \User.name) var users: [User]
    
    @Environment(\.modelContext) var modelContext
    @State var sortOrder = [SortDescriptor(\ExpenseItem.name)]
//    @Query(sort: sortOrder) var expenses: [ExpenseItem]
    @Query var expenses: [ExpenseItem]
    // using this as condition for showing a sheet
    @State private var showingAddExpense = false
    var body: some View {
        NavigationStack{
            List{
                // don't need the id: \.id anymore because we use the Identifiable protocol, Swift knows there is a unique id
                Section("Personal Expenses"){
                    ForEach(expenses){ item in
                        if item.type == "Personal" {
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(item.name).font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .fontWeight(item.amount < 10.0 ? .light: item.amount < 100 ? .bold : .heavy)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                Section("Business Expenses"){
                    ForEach(expenses){ item in
                        if item.type == "Business"{
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(item.name).font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .fontWeight(item.amount < 10.0 ? .light: item.amount < 100 ? .bold : .heavy)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar {
                
                Button("Add expense", systemImage: "plus"){
                    showingAddExpense = true
                }
                Button("Filter", systemImage: "line.3.horizontal.decrease.circle"){
                    print("filter")
                    sortOrder = [SortDescriptor(\ExpenseItem.amount)]
                    print(sortOrder)
                }
                
            }
            .sheet(isPresented: $showingAddExpense, content: {
                AddView()
            })
        }
    }
    
    init(sortOrder: [SortDescriptor<ExpenseItem>]){
        _expenses = Query(sort: sortOrder)
    }
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our query
            let item = expenses[offset]
            
            // delete it from the context
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView(sortOrder: [SortDescriptor(\ExpenseItem.name)])
}
