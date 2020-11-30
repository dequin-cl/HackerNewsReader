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
}

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}
