//
//  RoutineDayDetailView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

struct RoutineDayDetailView: View {
    @Bindable var day: RoutineDay
    let routineScheduleType: ScheduleType
    @Environment(\.modelContext) private var modelContext

    @State private var selectedMuscleGroup: MuscleGroup = .chest
    @State private var editingExercise: ExerciseTemplate?
    @State private var customExerciseName = ""

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        List {
            Section {
                TextField("Day Name", text: $day.name)
                Toggle("Rest Day", isOn: $day.isRestDay)
            }

            if day.isRestDay {
                Section {
                    Label("This is a rest day — no exercises needed", systemImage: "moon.zzz.fill")
                        .foregroundStyle(.secondary)
                }
            } else {
                Section("Schedule") {
                    if routineScheduleType == .fixedWeekday {
                        ForEach(1...7, id: \.self) { weekday in
                            Toggle(weekdayName(weekday), isOn: Binding(
                                get: { day.daysOfWeek.contains(weekday) },
                                set: { isOn in
                                    if isOn {
                                        day.daysOfWeek.append(weekday)
                                    } else {
                                        day.daysOfWeek.removeAll { $0 == weekday }
                                    }
                                }
                            ))
                        }
                    } else {
                        Stepper("Cycle Position: Day \(day.order + 1)", value: $day.order, in: 0...20)
                    }
                }

                Section("Exercises") {
                    ForEach(day.plannedExercises) { exercise in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(exercise.name)
                                Text(exercise.toFailure ? "\(exercise.targetSets) sets to failure 🔥" : "\(exercise.targetSets) sets x \(exercise.targetReps) reps")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            VStack(spacing: 0) {
                                Text(exercise.targetWeight, format: .number)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("lbs")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingExercise = exercise
                        }
                    }
                    .onDelete(perform: deleteExercises)
                    .onMove(perform: moveExercises)
                }

                Section("Add an exercise") {
                    Picker("Muscle Group", selection: $selectedMuscleGroup) {
                        ForEach(MuscleGroup.allCases, id: \.self) { group in
                            Text(group.rawValue.capitalized).tag(group)
                        }
                    }
                    .pickerStyle(.menu)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(ExerciseCatalog.suggestions[selectedMuscleGroup] ?? []) { suggestion in
                            Button {
                                addExercise(named: suggestion.name, group: selectedMuscleGroup)
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
                    .padding(.vertical, 6)

                    HStack {
                        Image(systemName: "plus.circle")
                        TextField("Custom exercise name", text: $customExerciseName)
                        Button("Add") {
                            addExercise(named: customExerciseName, group: selectedMuscleGroup)
                            customExerciseName = ""
                        }
                        .disabled(customExerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .navigationTitle(day.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(item: $editingExercise) { exercise in
            EditExerciseSheet(exercise: exercise)
        }
    }

    private func weekdayName(_ weekday: Int) -> String {
        let symbols = Calendar.current.weekdaySymbols
        return symbols[weekday - 1]
    }

    private func addExercise(named name: String, group: MuscleGroup) {
        withAnimation {
            let exercise = ExerciseTemplate(
                name: name,
                muscleGroup: group,
                targetSets: 3,
                targetReps: 10
            )
            day.plannedExercises.append(exercise)
        }
    }

    private func deleteExercises(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let exercise = day.plannedExercises[index]
                modelContext.delete(exercise)
            }
            day.plannedExercises.remove(atOffsets: offsets)
        }
    }

    private func moveExercises(from source: IndexSet, to destination: Int) {
        day.plannedExercises.move(fromOffsets: source, toOffset: destination)
    }
}
