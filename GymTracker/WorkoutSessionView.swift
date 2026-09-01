//
//  WorkoutSessionView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

private struct SessionExercise: Identifiable {
    let id = UUID()
    var name: String
    var muscleGroup: MuscleGroup
    var wasSwapped: Bool = false
    var sets: [SessionSet] = []
}

private struct SessionSet: Identifiable {
    let id = UUID()
    var reps: Int = 10
    var weight: Double = 0
    var toFailure: Bool = false
}

struct WorkoutSessionView: View {
    let day: RoutineDay

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var exercises: [SessionExercise] = []
    @State private var swappingIndex: Int?

    var body: some View {
        List {
            ForEach(exercises.indices, id: \.self) { index in
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(exercises[index].name)
                                .font(.headline)
                            if exercises[index].wasSwapped {
                                Text("Swapped")
                                    .font(.caption2)
                                    .foregroundStyle(.orange)
                            }
                        }
                        Spacer()
                        Button("Swap") {
                            swappingIndex = index
                        }
                        .font(.caption)
                    }

                    ForEach(exercises[index].sets.indices, id: \.self) { setIndex in
                        HStack {
                            Text("Set \(setIndex + 1)")
                                .foregroundStyle(.secondary)
                            Spacer()
                            TextField("lbs", value: $exercises[index].sets[setIndex].weight, format: .number)
                                .keyboardType(.decimalPad)
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)
                            Text("x")
                                .foregroundStyle(.secondary)
                            TextField("reps", value: $exercises[index].sets[setIndex].reps, format: .number)
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                                .textFieldStyle(.roundedBorder)
                                .disabled(exercises[index].sets[setIndex].toFailure)
                            Toggle(isOn: $exercises[index].sets[setIndex].toFailure) {
                                Text("🔥")
                            }
                            .labelsHidden()
                            .toggleStyle(.button)
                        }
                    }

                    Button {
                        exercises[index].sets.append(SessionSet())
                    } label: {
                        Label("Add Set", systemImage: "plus")
                    }
                    .font(.caption)
                }
            }
        }
        .navigationTitle(day.name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Finish") {
                    finishSession()
                }
            }
        }
        .sheet(item: Binding(
            get: { swappingIndex.map { IndexWrapper(value: $0) } },
            set: { swappingIndex = $0?.value }
        )) { wrapper in
            SwapExerciseSheet(muscleGroup: exercises[wrapper.value].muscleGroup) { suggestion in
                exercises[wrapper.value].name = suggestion.name
                exercises[wrapper.value].wasSwapped = true
            }
        }
        .onAppear {
            if exercises.isEmpty {
                exercises = day.plannedExercises.map { template in
                    SessionExercise(
                        name: template.name,
                        muscleGroup: template.muscleGroup,
                        sets: (0..<template.targetSets).map { _ in
                            SessionSet(reps: template.targetReps, weight: template.targetWeight, toFailure: template.toFailure)
                        }
                    )
                }
            }
        }
    }

    private func finishSession() {
        let loggedExercises = exercises.map { ex -> LoggedExercise in
            let sets = ex.sets.map { LoggedSet(reps: $0.reps, weight: $0.weight, toFailure: $0.toFailure) }
            return LoggedExercise(name: ex.name, muscleGroup: ex.muscleGroup, wasSwapped: ex.wasSwapped, sets: sets)
        }
        let loggedDay = LoggedDay(date: Date(), routineDayName: day.name, loggedExercises: loggedExercises)
        modelContext.insert(loggedDay)
        dismiss()
    }
}

private struct IndexWrapper: Identifiable {
    let value: Int
    var id: Int { value }
}
