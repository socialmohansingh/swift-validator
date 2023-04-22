//  TextModelResult.swift
//  Created by bemohansingh on 07/04/2021.


import UIKit

/// The result of the interactor for the bounded textField
public struct TextModelResult {
    
    // The textfield bounded to this model
    public var element: TextAssignable?
    
    // The value in the textField
    public var value: String
    
    // The error from interactor if present
    public var error: Error?
    
    // The interactor
    public var interactor: Interactor
}
