//
//  ExerciseTemplate.swift
//  GymTracker
//

import Foundation
import SwiftData

enum MuscleGroup: String, Codable, CaseIterable {
    case chest
    case back
    case legs
    case shoulders
    case arms
    case core
}

@Model
final class ExerciseTemplate {
    var name: String
    var muscleGroup: MuscleGroup
    var targetSets: Int
    var targetReps: Int
    var targetWeight: Double
    var toFailure: Bool

    init(name: String, muscleGroup: MuscleGroup, targetSets: Int, targetReps: Int, targetWeight: Double = 0, toFailure: Bool = false) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.targetSets = targetSets
        self.targetReps = targetReps
        self.targetWeight = targetWeight
        self.toFailure = toFailure
    }
}
