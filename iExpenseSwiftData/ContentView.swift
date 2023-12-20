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
    var name: String
    var type: String
    var amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}

@Model
class Expenses {
    var items = [ExpenseItem]()
    
    init(items: [ExpenseItem] = [ExpenseItem]()) {
        self.items = items
    }
}
 

struct ContentView: View {
    @Query var expenses: Expenses
    // using this as condition for showing a sheet
    @State private var showingAddExpense = false
    var body: some View {
        NavigationStack{
            List{
                // don't need the id: \.id anymore because we use the Identifiable protocol, Swift knows there is a unique id
                Section("Personal Expenses"){
                    ForEach(expenses.items){ item in
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
                    ForEach(expenses.items){ item in
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
            }
            .sheet(isPresented: $showingAddExpense, content: {
                AddView(expenses: expenses)
            })
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
