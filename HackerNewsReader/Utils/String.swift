//
//  String.swift
//  OrthoKeys
//
//  Created by Iván GalazJeria on 09-01-20.
//  Copyright © 2020 OrthoPlus SpA. All rights reserved.
//

import Foundation

extension String {
    func defaultNonLocalizedValue() -> String {
        return "**\(self)**"
    }

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: defaultNonLocalizedValue(), comment: "")
    }

    /// Fetches a localised String Arguments
    ///
    /// - Parameter arguments: parameters to be added in a string
    /// - Returns: localized string
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized(), locale: nil, arguments: arguments)
    }
}

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
    func localized(with arguments: [CVarArg]) -> String
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }

    func localized(with arguments: [CVarArg]) -> String {
        return rawValue.localized(with: arguments)
    }
}
