//
//  Person.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import Foundation

struct Person: Identifiable, Codable {
    let id: UUID
    var name: String
    var shares: Int
    var percentage: Double
    var amount: Double
    
    init(id: UUID = UUID(), name: String, shares: Int = 1, percentage: Double = 0.0, amount: Double = 0.0) {
        self.id = id
        self.name = name
        self.shares = shares
        self.percentage = percentage
        self.amount = amount
    }
}
