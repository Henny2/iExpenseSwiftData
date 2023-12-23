//
//  ExpesnseListView.swift
//  iExpenseSwiftData
//
//  Created by Henrieke Baunack on 12/22/23.
//
import SwiftData
import SwiftUI

struct ExpesnseListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    init(filter: String, sort: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(filter: #Predicate {
            if filter.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(filter)
            }
        }, sort: sort)
    }
    var body: some View {
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
    ExpesnseListView(filter: "" , sort: [SortDescriptor(\ExpenseItem.name)])
}
