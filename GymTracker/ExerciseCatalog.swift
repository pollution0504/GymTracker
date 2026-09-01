//
//  ExerciseCatalog.swift
//  GymTracker
//

import Foundation

struct SuggestedExercise: Identifiable {
    let id = UUID()
    let name: String
    let icon: String // SF Symbol name
}

enum ExerciseCatalog {
    static let suggestions: [MuscleGroup: [SuggestedExercise]] = [
        .chest: [
            SuggestedExercise(name: "Bench Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Incline Dumbbell Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Cable Fly", icon: "figure.arms.open"),
            SuggestedExercise(name: "Push-Up", icon: "figure.core.training"),
            SuggestedExercise(name: "Decline Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Incline Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Super Incline Bench Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Pectoral Fly", icon: "figure.arms.open")
        ],
        .back: [
            SuggestedExercise(name: "Pull-Up", icon: "figure.strengthtraining.functional"),
            SuggestedExercise(name: "Barbell Row", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Lat Pulldown", icon: "arrow.down.to.line"),
            SuggestedExercise(name: "Deadlift", icon: "figure.strengthtraining.functional"),
            SuggestedExercise(name: "Rope Pull Up", icon: "arrow.down.to.line"),
            SuggestedExercise(name: "Bench Row", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Front Lat Pulldown", icon: "arrow.down.to.line"),
            SuggestedExercise(name: "Row Cables", icon: "arrow.left.and.right")
        ],
        .legs: [
            SuggestedExercise(name: "Squat", icon: "figure.cross.training"),
            SuggestedExercise(name: "Leg Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Romanian Deadlift", icon: "figure.strengthtraining.functional"),
            SuggestedExercise(name: "Walking Lunge", icon: "figure.walk")
        ],
        .shoulders: [
            SuggestedExercise(name: "Overhead Press", icon: "figure.strengthtraining.traditional"),
            SuggestedExercise(name: "Lateral Raise", icon: "figure.arms.open"),
            SuggestedExercise(name: "Face Pull", icon: "arrow.left.and.right"),
            SuggestedExercise(name: "Rear Delt Fly", icon: "figure.arms.open")
        ],
        .arms: [
            SuggestedExercise(name: "Bicep Curl", icon: "dumbbell.fill"),
            SuggestedExercise(name: "Tricep Pushdown", icon: "arrow.down.to.line"),
            SuggestedExercise(name: "Hammer Curl", icon: "dumbbell.fill"),
            SuggestedExercise(name: "Skull Crusher", icon: "dumbbell.fill"),
            SuggestedExercise(name: "Ind. Bicep Curl", icon: "dumbbell.fill"),
            SuggestedExercise(name: "Bicep Curl (Long Bar)", icon: "dumbbell.fill"),
            SuggestedExercise(name: "Tricep Pushdown (Cable)", icon: "arrow.down.to.line"),
            SuggestedExercise(name: "Tricep Pushdown (Machine)", icon: "arrow.down.to.line"),
            SuggestedExercise(name: "Seated Dip", icon: "figure.strengthtraining.traditional")
        ],
        .core: [
            SuggestedExercise(name: "Plank", icon: "figure.core.training"),
            SuggestedExercise(name: "Hanging Leg Raise", icon: "figure.core.training"),
            SuggestedExercise(name: "Cable Crunch", icon: "figure.core.training"),
            SuggestedExercise(name: "Russian Twist", icon: "figure.core.training")
        ]
    ]
}
