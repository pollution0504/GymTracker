//
//  EditExerciseSheet.swift
//  GymTracker
//

import SwiftUI

struct EditExerciseSheet: View {
    @Bindable var exercise: ExerciseTemplate
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(exercise.name)
                        .font(.headline)
                }

                Section("Sets & Reps") {
                    Stepper("Sets: \(exercise.targetSets)", value: $exercise.targetSets, in: 1...10)
                    Stepper("Reps: \(exercise.targetReps)", value: $exercise.targetReps, in: 1...30)
                        .disabled(exercise.toFailure)
                    HStack {
                        Text("Weight (lbs)")
                        Spacer()
                        TextField("0", value: $exercise.targetWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section {
                    Toggle(isOn: $exercise.toFailure) {
                        Label("To Failure 🔥", systemImage: "flame.fill")
                    }
                }
            }
            .navigationTitle("Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
