//
//  RootTabView.swift
//  GymTracker
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ContentView()
                .tabItem {
                    Label("My Routines", systemImage: "list.bullet.clipboard")
                }

            LogWorkoutView()
                .tabItem {
                    Label("Log Workout", systemImage: "plus.circle.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
