//
//  RoutinePresets.swift
//  GymTracker
//

import Foundation

struct PresetExercise {
    let name: String
    let muscleGroup: MuscleGroup
    let sets: Int
    let reps: Int
}

struct PresetDay {
    let name: String
    let exercises: [PresetExercise]
}

struct RoutinePreset: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let type: RoutineType
    let icon: String
    let isCustomImage: Bool
    let scheduleType: ScheduleType
    let days: [PresetDay]
}

enum RoutinePresets {
    static let all: [RoutinePreset] = [
        RoutinePreset(
            name: "Push Pull Legs",
            description: "A classic 3-day split organized by movement pattern — great for building strength and size with balanced recovery.",
            type: .ppl,
            icon: "figure.strengthtraining.traditional",
            isCustomImage: false,
            scheduleType: .rotatingCycle,
            days: [
                PresetDay(name: "Push", exercises: [
                    PresetExercise(name: "Bench Press", muscleGroup: .chest, sets: 4, reps: 8),
                    PresetExercise(name: "Overhead Press", muscleGroup: .shoulders, sets: 3, reps: 10),
                    PresetExercise(name: "Incline Dumbbell Press", muscleGroup: .chest, sets: 3, reps: 10),
                    PresetExercise(name: "Tricep Pushdown", muscleGroup: .arms, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Pull", exercises: [
                    PresetExercise(name: "Deadlift", muscleGroup: .back, sets: 3, reps: 6),
                    PresetExercise(name: "Pull-Up", muscleGroup: .back, sets: 3, reps: 8),
                    PresetExercise(name: "Barbell Row", muscleGroup: .back, sets: 3, reps: 10),
                    PresetExercise(name: "Bicep Curl", muscleGroup: .arms, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Legs", exercises: [
                    PresetExercise(name: "Squat", muscleGroup: .legs, sets: 4, reps: 8),
                    PresetExercise(name: "Romanian Deadlift", muscleGroup: .legs, sets: 3, reps: 10),
                    PresetExercise(name: "Leg Press", muscleGroup: .legs, sets: 3, reps: 12),
                    PresetExercise(name: "Walking Lunge", muscleGroup: .legs, sets: 3, reps: 12)
                ])
            ]
        ),
        RoutinePreset(
            name: "Arnold Split",
            description: "A 3-day bodybuilding split pairing opposing muscle groups per session, inspired by Arnold Schwarzenegger's classic training routine.",
            type: .arnold,
            icon: "arnoldFace",
            isCustomImage: true,
            scheduleType: .rotatingCycle,
            days: [
                PresetDay(name: "Chest & Back", exercises: [
                    PresetExercise(name: "Bench Press", muscleGroup: .chest, sets: 4, reps: 8),
                    PresetExercise(name: "Barbell Row", muscleGroup: .back, sets: 4, reps: 8),
                    PresetExercise(name: "Cable Fly", muscleGroup: .chest, sets: 3, reps: 12),
                    PresetExercise(name: "Lat Pulldown", muscleGroup: .back, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Shoulders & Arms", exercises: [
                    PresetExercise(name: "Overhead Press", muscleGroup: .shoulders, sets: 4, reps: 8),
                    PresetExercise(name: "Lateral Raise", muscleGroup: .shoulders, sets: 3, reps: 12),
                    PresetExercise(name: "Bicep Curl", muscleGroup: .arms, sets: 3, reps: 12),
                    PresetExercise(name: "Skull Crusher", muscleGroup: .arms, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Legs", exercises: [
                    PresetExercise(name: "Squat", muscleGroup: .legs, sets: 4, reps: 8),
                    PresetExercise(name: "Leg Press", muscleGroup: .legs, sets: 3, reps: 12),
                    PresetExercise(name: "Walking Lunge", muscleGroup: .legs, sets: 3, reps: 12)
                ])
            ]
        ),
        RoutinePreset(
            name: "4-Day Rotation",
            description: "A 4-day rotating split cycling through Arms, Chest & Back, Legs, and Forearms & Shoulders — repeats every 4 days regardless of weekday.",
            type: .custom,
            icon: "arrow.triangle.2.circlepath",
            isCustomImage: false,
            scheduleType: .rotatingCycle,
            days: [
                PresetDay(name: "Arms", exercises: [
                    PresetExercise(name: "Bicep Curl", muscleGroup: .arms, sets: 3, reps: 12),
                    PresetExercise(name: "Hammer Curl", muscleGroup: .arms, sets: 3, reps: 12),
                    PresetExercise(name: "Tricep Pushdown", muscleGroup: .arms, sets: 3, reps: 12),
                    PresetExercise(name: "Skull Crusher", muscleGroup: .arms, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Chest & Back", exercises: [
                    PresetExercise(name: "Bench Press", muscleGroup: .chest, sets: 4, reps: 8),
                    PresetExercise(name: "Barbell Row", muscleGroup: .back, sets: 4, reps: 8),
                    PresetExercise(name: "Cable Fly", muscleGroup: .chest, sets: 3, reps: 12),
                    PresetExercise(name: "Lat Pulldown", muscleGroup: .back, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Legs", exercises: [
                    PresetExercise(name: "Squat", muscleGroup: .legs, sets: 4, reps: 8),
                    PresetExercise(name: "Romanian Deadlift", muscleGroup: .legs, sets: 3, reps: 10),
                    PresetExercise(name: "Leg Press", muscleGroup: .legs, sets: 3, reps: 12),
                    PresetExercise(name: "Walking Lunge", muscleGroup: .legs, sets: 3, reps: 12)
                ]),
                PresetDay(name: "Forearms & Shoulders", exercises: [
                    PresetExercise(name: "Overhead Press", muscleGroup: .shoulders, sets: 4, reps: 8),
                    PresetExercise(name: "Lateral Raise", muscleGroup: .shoulders, sets: 3, reps: 12),
                    PresetExercise(name: "Rear Delt Fly", muscleGroup: .shoulders, sets: 3, reps: 12),
                    PresetExercise(name: "Wrist Curl", muscleGroup: .arms, sets: 3, reps: 15)
                ])
            ]
        )
    ]
}
