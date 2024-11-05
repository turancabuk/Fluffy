//
//  Ext+Int.swift
//  Fluffy
//
//  Created by Turan Çabuk on 5.11.2024.
//

import Foundation

extension Int {
    var toDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
