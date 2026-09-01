//
//  PresetPickerView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

struct PresetPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(RoutinePresets.all) { preset in
                    Button {
                        createRoutine(from: preset)
                    } label: {
                        HStack(spacing: 14) {
                            Group {
                                if preset.isCustomImage {
                                    Image(preset.icon)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                } else {
                                    Image(systemName: preset.icon)
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                        .frame(width: 40)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(preset.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text(preset.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Choose a Preset")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func createRoutine(from preset: RoutinePreset) {
        let days = preset.days.enumerated().map { index, presetDay in
            let exercises = presetDay.exercises.map { presetExercise in
                ExerciseTemplate(
                    name: presetExercise.name,
                    muscleGroup: presetExercise.muscleGroup,
                    targetSets: presetExercise.sets,
                    targetReps: presetExercise.reps
                )
            }
            return RoutineDay(name: presetDay.name, plannedExercises: exercises, order: index)
        }

        let routine = Routine(name: preset.name, type: preset.type, days: days, scheduleType: preset.scheduleType)
        modelContext.insert(routine)
        dismiss()
    }
}
