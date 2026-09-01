//
//  LoggedDayDetailView.swift
//  GymTracker
//

import SwiftUI

struct LoggedDayDetailView: View {
    let loggedDay: LoggedDay

    var body: some View {
        List {
            Section {
                Text(loggedDay.date.formatted(date: .complete, time: .shortened))
                    .foregroundStyle(.secondary)
            }

            ForEach(loggedDay.loggedExercises) { exercise in
                Section {
                    HStack {
                        Text(exercise.name)
                            .font(.headline)
                        if exercise.wasSwapped {
                            Text("Swapped")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.orange.opacity(0.2))
                                .foregroundStyle(.orange)
                                .clipShape(Capsule())
                        }
                    }

                    ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, set in
                        HStack {
                            Text("Set \(index + 1)")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if set.toFailure {
                                Text("\(set.weight, specifier: "%.1f") lbs to failure 🔥")
                            } else {
                                Text("\(set.weight, specifier: "%.1f") lbs x \(set.reps)")
                            }
                        }
                    }
                }
            }

            if let notes = loggedDay.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }
        }
        .navigationTitle(loggedDay.routineDayName)
    }
}
