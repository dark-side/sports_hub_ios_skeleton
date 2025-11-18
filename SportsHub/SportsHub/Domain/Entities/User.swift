//
//  User.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

struct User: Identifiable, Equatable {
    let id: Int
    let email: String
    let name: String
    let token: String?
}
