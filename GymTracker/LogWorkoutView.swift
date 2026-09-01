//
//  LogWorkoutView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

struct LogWorkoutView: View {
    @Query private var routines: [Routine]
    @State private var selectedDay: RoutineDay?

    var body: some View {
        NavigationStack {
            List {
                if allDays.isEmpty {
                    Text("Add a routine day on the Home tab first")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(allDays, id: \.id) { day in
                        Button {
                            selectedDay = day
                        } label: {
                            VStack(alignment: .leading) {
                                Text(day.name)
                                    .foregroundStyle(.primary)
                                Text("\(day.plannedExercises.count) exercise(s)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Start a workout")
            .navigationDestination(item: $selectedDay) { day in
                WorkoutSessionView(day: day)
            }
        }
    }

    private var allDays: [RoutineDay] {
        routines.flatMap { $0.days }
    }
}
