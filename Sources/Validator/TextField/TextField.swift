//  TextField.swift
//  Created by bemohansingh on 07/04/2021.

import UIKit

public protocol TextAssignable {
    var assignedText: String? { get set }
}

open class TextField: UITextField, TextAssignable {
    public var assignedText: String? {
        set {
            self.text = newValue
        } get {
            self.text
        }
    }
    
    public override var text: String? {
        didSet {
            sendActions(for: .editingChanged)
        }
    }
    
    public func validable(with interactor: Interactor) -> Validable {
        return Validable(self, interactor: interactor)
    }
}
