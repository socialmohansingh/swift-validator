//  Validator.swift
//  Created by bemohansingh on 07/04/2021.

import Foundation
import UIKit
import Combine

public class Validator {
    
    // private
    private var models = [TextModel]()
    public init() {}
    
    /// Method to start the validation of the models with the validables provided
    /// - Parameter validables: the validabel objects
    public func validate(_ validables: [Validable]) -> AnyPublisher<[TextModelResult], Never> {
        
        // create TextModel for validation
        models.removeAll()
        models = validables.map({ TextModel(interactor: $0.interactor, element: $0.element) })
        
        // combine and send the results
        return models.map({ $0.$publisher }).combineLatest.map{ (publishers) -> [TextModelResult] in
            return publishers.compactMap({ $0 })
        }.eraseToAnyPublisher()
    }
}
