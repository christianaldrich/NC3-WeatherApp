//
//  Time.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 11/07/24.
//

import Foundation


struct TimeRange: Codable, Identifiable, Hashable {
    let id = UUID()
    var startTime: Date
    var endTime: Date
    
    static func == (lhs: TimeRange, rhs: TimeRange) -> Bool {
        return lhs.id == rhs.id
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
