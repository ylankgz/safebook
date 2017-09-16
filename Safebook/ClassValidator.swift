//
//  UIClassValidator.swift
//  SelectableTextView
//
//  Created by Jeff Hurray on 2/20/17.
//  Copyright © 2017 jhurray. All rights reserved.
//
import Foundation
import SelectableTextView

public struct UIClassValidator: ContainerTextSelectionValidator {
    
    public init() {}
    
    public let validator: TextSelectionValidator = PrefixValidator(prefix: "*", caseSensitive: true)

    public var selectionAttributes: [String : Any]? = [
        NSForegroundColorAttributeName: UIColor.orange
    ]
}
