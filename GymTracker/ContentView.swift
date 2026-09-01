//
//  ContentView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routines: [Routine]
    @State private var showingPresetPicker = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(routines) { routine in
                    NavigationLink {
                        RoutineDetailView(routine: routine)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(routine.name)
                                .font(.headline)
                            Text("\(routine.days.count) day(s)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteRoutines)
            }
            .navigationTitle("Routines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Menu {
                        Button(action: addRoutine) {
                            Label("Blank Routine", systemImage: "doc")
                        }
                        Button {
                            showingPresetPicker = true
                        } label: {
                            Label("Choose a Preset", systemImage: "square.stack.3d.up")
                        }
                    } label: {
                        Label("Add Routine", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingPresetPicker) {
                PresetPickerView()
            }
        }
    }

    private func addRoutine() {
        withAnimation {
            let newRoutine = Routine(name: "New Routine", type: .custom)
            modelContext.insert(newRoutine)
        }
    }

    private func deleteRoutines(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(routines[index])
            }
        }
    }
}
