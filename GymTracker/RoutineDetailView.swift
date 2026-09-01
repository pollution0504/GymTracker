//
//  RoutineDetailView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

struct RoutineDetailView: View {
    @Bindable var routine: Routine
    @Query private var allRoutines: [Routine]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            Section {
                TextField("Routine Name", text: $routine.name)
            }

            Section("Schedule") {
                Picker("Schedule Type", selection: $routine.scheduleType) {
                    Text("Fixed Weekday").tag(ScheduleType.fixedWeekday)
                    Text("Rotating Cycle").tag(ScheduleType.rotatingCycle)
                }
                .pickerStyle(.segmented)

                if routine.scheduleType == .rotatingCycle {
                    DatePicker("Cycle Start", selection: $routine.cycleStartDate, displayedComponents: .date)
                }
            }

            Section {
                Toggle("Main Routine", isOn: Binding(
                    get: { routine.isMainRoutine },
                    set: { newValue in
                        if newValue {
                            setAsMainRoutine()
                        } else {
                            routine.isMainRoutine = false
                        }
                    }
                ))
            } footer: {
                Text("Home will show today's plan from your Main Routine.")
            }

            Section("Days") {
                ForEach(routine.days) { day in
                    NavigationLink(day.name) {
                        RoutineDayDetailView(day: day, routineScheduleType: routine.scheduleType)
                    }
                }
                .onDelete(perform: deleteDays)

                Button(action: addDay) {
                    Label("Add Day", systemImage: "plus")
                }

                Button(action: addRestDay) {
                    Label("Add Break", systemImage: "moon.zzz.fill")
                }
            }
        }
        .navigationTitle(routine.name)
    }

    private func setAsMainRoutine() {
        for other in allRoutines where other.persistentModelID != routine.persistentModelID {
            other.isMainRoutine = false
        }
        routine.isMainRoutine = true
    }

    private func addDay() {
        withAnimation {
            let newDay = RoutineDay(name: "New Day")
            routine.days.append(newDay)
        }
    }

    private func addRestDay() {
        withAnimation {
            let restDay = RoutineDay(name: "Rest", isRestDay: true)
            routine.days.append(restDay)
        }
    }

    private func deleteDays(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let day = routine.days[index]
                modelContext.delete(day)
            }
            routine.days.remove(atOffsets: offsets)
        }
    }
}

