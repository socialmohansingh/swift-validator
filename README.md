# Validator

A textfield and TextView text validator for ios application

# Usage
1. Use TextField or TextView class from the package. If we need we can inherit to add extra functionality.

2. When the fields or textviews are created  we need to set them to validate. to do that we will need an Interactor and regex pattern. like so:

```swift
enum Pattern: PatternIdentifiable {
    case email
    case password
    
    var identifier: (expression: String, dataType: String) {
        switch self {
        case .email:
            return ("RegEX for email", "Email")
        case .password:
            return ("RegEX for password", "Password")
        }
    }
}


struct TextInteractor: Interactor {
    var isOptional: Bool
    var pattern: PatternIdentifiable
    var emptyMessage: String
    var validationFailedMessage: String
    
    init(pattern: PatternIdentifiable, optional: Bool, emptyMessage: String, validationFailedMessage: String) {
        self.isOptional = optional
        self.pattern = pattern
        self.emptyMessage = emptyMessage
        self.validationFailedMessage = validationFailedMessage
    }
}
```

3. After these are build we create the instance of validator.
    ```swift
    let validator = Validator()
    ```
4. Now we are ready to mark our textfields or textviews as validables
```swift
cancellable = validator.validate([
            emailTextField.validable(with: TextInteractor(pattern: Pattern.email, optional: false, emptyMessage: "Please provide email", validationFailedMessage: "Please provide valid message")),
            passwordTextField.validable(with: TextInteractor(pattern: Pattern.password, optional: false, emptyMessage: "Please provide password", validationFailedMessage: "Please provide valid password"))
        ]).sink { result in
            debugPrint(result)
        }
```

The result will have the validation result from the interactor. If we need to validate not only empty or regex, we can implement following function from interactor.
```swift
func patternValidationResult(validationError: InteractorError?) -> InteractorError? 
```

The result returned is of TextModelResult from validator.

```swift
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

```

1. `element` is the element we are valodating i.e TextFeidl or TextView
2. `value` will be the value in of the element
3. `error` is the error from the validation of value
4. `interactor` is the interactor used to validate