//  Interactor.swift
//  Created by bemohansingh on 07/04/2021.

import Foundation

public enum InteractorError: LocalizedError {
    case empty(String), validationFailed(String)
    public var errorDescription: String? {
        switch self {
        case .empty(let reason), .validationFailed(let reason):
            return reason
        }
    }
}

public protocol Interactor {
    
    /// Flag to indicate the value is required or optional
    var isOptional: Bool { get set }
    
    /// The pattern to validate against
    var pattern: PatternIdentifiable { get set }
    
    /// The message when the required value is empty
    var emptyMessage: String { get set }
    
    /// The message when the validation failed
    var validationFailedMessage: String { get set }
    
    /// Reuqired initializer
    init(pattern: PatternIdentifiable, optional: Bool, emptyMessage: String, validationFailedMessage: String)
    
    /// method that will try to validate the value
    func validate(value: String) -> Error?
    
    // Method that will be triggered after the validation with regEx is completed so that the child class can validate further if required
    func patternValidationResult(value: String, validationError: InteractorError?) -> InteractorError?
}

/// The interactable protocol that will be available for the interactors used for validating specific testField types
public extension Interactor {
    
    /// Method that will validate the value from TextField
    /// - Parameter value: The value to validate
    func validate(value: String) -> Error? {
        
        // check and continue if we need to skip the validation
        let skipValidation = value.isEmpty && isOptional
        guard !skipValidation else {
            return patternValidationResult(value: value, validationError: nil)
        }
        
        // The error object
        var validationError: InteractorError?
        
        // check if required value is empty
        if value.isEmpty {
            validationError = InteractorError.empty(emptyMessage)
        }
       
        // check if regular expression matches
        let result = RegExMatcher.validate(value: value, for: pattern)
        
        // check if validation failed
        if !result {
            validationError = InteractorError.validationFailed(validationFailedMessage)
        }
        
        // everything seems ok!
        return patternValidationResult(value: value, validationError: validationError)
    }
    
    // return the received error so that default implementation detail is met
    func patternValidationResult(value: String, validationError: InteractorError?) -> InteractorError? {
        return validationError
    }
}
