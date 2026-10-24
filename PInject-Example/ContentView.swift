//
//  ContentView.swift
//  PInject-Example
//
//  Created by Rahmat Trinanda Pramudya Amar on 24/10/26.
//

import SwiftUI
import PInject

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                AuthDemoView()
            }
            .tabItem {
                Label("Auth (@Inject)", systemImage: "person.badge.key.fill")
            }

            NavigationStack {
                TransientDemoView()
            }
            .tabItem {
                Label("Transient", systemImage: "arrow.triangle.2.circlepath")
            }

            NavigationStack {
                AnalyticsLogsView()
            }
            .tabItem {
                Label("Analytics", systemImage: "chart.xyaxis.line")
            }

            NavigationStack {
                ContainerInspectorView()
            }
            .tabItem {
                Label("Inspector", systemImage: "slider.horizontal.3")
            }
        }
    }
}

#Preview {
    AppDependencies.setup()
    return ContentView()
}
