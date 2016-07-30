//
//  CustomExclusiveCondition.swift
//  PowerDot-Athlete
//
//  Created by d503 on 7/10/16.
//  Copyright © 2016 Polecat. All rights reserved.
//

import Foundation
import Operations

protocol CustomExclusiveOperation {
    var customExclusiveConditions: [CustomExclusiveOperationCondition] { get }
}

protocol CustomExclusiveOperationCondition: OperationCondition {
    var exclusivityIdentifier: String { get }
}

class CustomExclusive: CustomExclusiveOperationCondition {
    
    var name: String {
        return "\(self.dynamicType)"
    }
    
    var exclusivityIdentifier: String {
        return "\(self.dynamicType)"
    }
    
    let isMutuallyExclusive = false
    
    /// Conforms to `OperationCondition`, but there are no dependencies, so it returns .None.
    func dependencyForOperation(operation: Operation) -> NSOperation? {
        return .None
    }
    
    /// Conforms to `OperationCondition`, but there is no evaluation, so it just completes with `.Satisfied`.
    func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        completion(.Satisfied)
    }
    
}
