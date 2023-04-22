//  Validable.swift
//  Created by bemohansingh on 07/04/2021.

public struct Validable {
    var element: TextAssignable
    var interactor: Interactor
    
    public init(_ element: TextAssignable, interactor: Interactor) {
        self.element = element
        self.interactor = interactor
    }
}
