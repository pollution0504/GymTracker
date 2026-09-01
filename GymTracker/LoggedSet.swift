//
//  LoggedSet.swift
//  GymTracker
//

import Foundation
import SwiftData

@Model
final class LoggedSet {
    var reps: Int
    var weight: Double
    var toFailure: Bool

    init(reps: Int, weight: Double, toFailure: Bool = false) {
        self.reps = reps
        self.weight = weight
        self.toFailure = toFailure
    }
}
