//  TextView.swift
//
//  Created by bemohansingh on 07/04/2021.

import UIKit

public class TextView: UITextView, TextAssignable {
    public var assignedText: String? {
        set {
            self.text = newValue
        } get {
            self.text
        }
    }
    public func validable(with interactor: Interactor) -> Validable {
        return Validable(self, interactor: interactor)
    }
}
