//
//  Animal.swift
//  AnimalSpotter
//
//  Created by Aaron Cleveland on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class Animal: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let timeSeen: Date
    let description: String
    let imageURL: String
}
