//
//  PInject_ExampleApp.swift
//  PInject-Example
//
//  Created by Rahmat Trinanda Pramudya Amar on 24/10/26.
//

import SwiftUI
import PInject

@main
struct PInject_ExampleApp: App {

    init() {
        // Bootstrap all application dependencies into PIContainer.shared
        AppDependencies.setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
