//
//  iExpenseSwiftDataApp.swift
//  iExpenseSwiftData
//
//  Created by Henrieke Baunack on 12/19/23.
//

import SwiftUI
import SwiftData

@main
struct iExpenseSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Expenses.self)
    }
}
