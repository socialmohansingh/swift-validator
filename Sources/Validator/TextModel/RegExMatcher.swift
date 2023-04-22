//  RegExMatcher.swift
//  Created by bemohansingh on 07/04/2021.

import Foundation

// This protocol will be used fo pattern supported by app
public protocol PatternIdentifiable {
    var identifier: (expression: String, dataType: String) { get }
}

public final class RegExMatcher {
    static func validate(value: String, for pattern: PatternIdentifiable) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", pattern.identifier.expression).evaluate(with: value)
    }
}
