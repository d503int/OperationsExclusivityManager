//
//  UnitTestOperationQueue.swift
//  PowerDot-Athlete
//
//  Created by d503 on 6/24/16.
//  Copyright © 2016 Polecat. All rights reserved.
//

import Foundation
@testable import PowerDot_Athlete
@testable import Operations

final class UnitTestOperationQueue: CustomExclusivityQueue {
    private let exclusivityManager = UnitTestExclusivityManager()
    
    override func addOperation(operation: NSOperation) {
        
        if let operation = operation as? Operation {
            
            let testExclusive = operation.conditions.filter {
                if let testExclusiveCondition =  $0 as? UnitTestMutuallyExclusiveOperationCondition {
                    return testExclusiveCondition.isMutuallyExclusiveForTests
                }
                else {
                    return false
                }
            }

            for condition in testExclusive {
                let category = "\(condition.dynamicType)"
                let mutuallyExclusiveOperation: NSOperation = condition.dependencyForOperation(operation) ?? operation
                exclusivityManager.addOperation(mutuallyExclusiveOperation, category: category)
            }
        }
        
        super.addOperation(operation)
    }
}