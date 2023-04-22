//  TextModel.swift
//  Created by bemohansingh on 07/04/2021.


import Foundation
import UIKit
import Combine

/// The textModel class that will handle all the vaidation of data publish the result
class TextModel: NSObject {
    
    /// The TextField for this model
    private var textField: TextField?
    
    /// The textView for the model
    private var textView: TextView?
    
    /// The value of the textField
    public var value: String {
        if textField != nil {
            return textField?.text ?? ""
        } else if textView != nil {
            return textView?.text ?? ""
        } else {
            return ""
        }
    }
    
    /// The intercator for the model
    private var interactor: Interactor
    
    /// The result publisher
    @Published public var publisher: TextModelResult
    
    /// Initializer
    init(interactor: Interactor, element: TextAssignable) {
        self.interactor = interactor
        self.publisher = TextModelResult(element: textField, value: element.assignedText ?? "", error: nil, interactor: interactor)
        super.init()
        self.bindAssignable(element)
    }
    
    private func bindAssignable(_ element: TextAssignable) {
        if let textField = element as? TextField {
            bind(textField)
        } else if let textView = element as? TextView {
            bind(textView)
        } else {
            assertionFailure("Invalid element for binding")
        }
    }
    
    /// Bind the textField to this model
    /// - Parameter textField: the textField to bind
    private func bind(_ element: TextField) {
        self.textField = element
        element.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let error = interactor.validate(value: element.text ?? "")
        self.publisher = TextModelResult(element: textField, value: value, error: error, interactor: interactor)
    }
    
    /// Binds a textView to this model
    /// - Parameter textView: the textView to bind
    private func bind(_ element: TextView) {
        self.textView = element
        self.textView?.delegate = self
        let error = interactor.validate(value: element.text ?? "")
        self.publisher = TextModelResult(element: textView, value: value, error: error, interactor: interactor)
    }
    
    /// sets the value and validate the text inside textField
    /// - Parameters:
    ///   - text: the text
    ///   - field: the textField
    private func setValue(with text: String, element: TextAssignable?) {
        let error = interactor.validate(value: text)
        publisher = TextModelResult(element: element, value: text, error: error, interactor: interactor)
    }
}

/// Extension to handle the observer for UITextField
extension TextModel {
    @objc private func textFieldDidChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.setValue(with: text, element: self.textField)
    }
}

/// Extensio to handle the observer for UITextField
extension TextModel: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        setValue(with: text, element: self.textView)
    }
    
    @objc private func textViewChanged() {
        guard let text = textView?.text else { return }
        setValue(with: text, element: self.textView)
    }
}

