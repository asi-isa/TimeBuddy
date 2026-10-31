//
//  TimeZone-FormattedName.swift
//  TimeBuddy
//
//  Created by Ali Soner Inceoglu on 30.10.26.
//

import Foundation

extension TimeZone {
    var formattedName: String {
        let start = localizedName(for: .generic, locale: .current) ?? "Unknown"
        return "\(start) - \(identifier)"
    }
}
