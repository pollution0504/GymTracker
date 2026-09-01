//
//  LoggedExercise.swift
//  GymTracker
//

import Foundation
import SwiftData

@Model
final class LoggedExercise {
    var name: String
    var muscleGroup: MuscleGroup
    var wasSwapped: Bool
    var sets: [LoggedSet]

    init(name: String, muscleGroup: MuscleGroup, wasSwapped: Bool = false, sets: [LoggedSet] = []) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.wasSwapped = wasSwapped
        self.sets = sets
    }
}
