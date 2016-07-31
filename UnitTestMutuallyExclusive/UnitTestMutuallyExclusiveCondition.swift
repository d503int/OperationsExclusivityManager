//
//  UnitTestMutuallyExclusiveCondition.swift
//  PowerDot-Athlete
//
//  Created by d503 on 6/24/16.
//  Copyright © 2016 Polecat. All rights reserved.
//

import Foundation
import Operations

protocol UnitTestMutuallyExclusiveOperationCondition: OperationCondition {
    var isMutuallyExclusiveForTests: Bool { get }
}

struct UnitTestMutuallyExclusive<T>: UnitTestMutuallyExclusiveOperationCondition {
    
    var name: String {
        return "\(self.dynamicType)"
    }
    
    let isMutuallyExclusive = false
    
    let isMutuallyExclusiveForTests = true
    
    init() { }
    
    /// Conforms to `OperationCondition`, but there are no dependencies, so it returns .None.
    func dependencyForOperation(operation: Operation) -> NSOperation? {
        return .None
    }
    
    /// Conforms to `OperationCondition`, but there is no evaluation, so it just completes with `.Satisfied`.
    func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        completion(.Satisfied)
    }

}
