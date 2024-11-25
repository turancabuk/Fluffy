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

func changeToDate(unixTimestamp: Int) -> String {
    let date = unixTimestamp.toDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current

    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}
