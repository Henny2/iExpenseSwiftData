//
//  ContentView.swift
//  iExpenseSwiftData
//
//  Created by Henrieke Baunack on 12/19/23.
//

import SwiftUI
import Observation

// protocol Identifiable
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            //[ExpenseItem].self means the type of array expenseitems
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}


struct ContentView: View {
    @State private var expenses = Expenses()
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
