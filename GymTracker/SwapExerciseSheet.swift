//
//  SwapExerciseSheet.swift
//  GymTracker
//

import SwiftUI

struct SwapExerciseSheet: View {
    let muscleGroup: MuscleGroup
    let onSelect: (SuggestedExercise) -> Void
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(ExerciseCatalog.suggestions[muscleGroup] ?? []) { suggestion in
                        Button {
                            onSelect(suggestion)
                            dismiss()
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: suggestion.icon)
                                    .font(.title2)
                                Text(suggestion.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Swap Exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
