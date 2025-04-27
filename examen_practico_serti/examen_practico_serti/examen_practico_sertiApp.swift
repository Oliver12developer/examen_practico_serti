//
//  examen_practico_sertiApp.swift
//  examen_practico_serti
//
//  Created by Oliver Suarez on 26/04/25.
//

import SwiftUI

@main
struct examen_practico_sertiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
