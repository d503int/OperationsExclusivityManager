//
//  CustomExclusivityQueue.swift
//  PowerDot-Athlete
//
//  Created by d503 on 7/10/16.
//  Copyright © 2016 Polecat. All rights reserved.
//

import Foundation
import Operations

class CustomExclusivityQueue: OperationQueue {
    private let customExclusivityManager = CustomExclusivityManager()
    
    override func addOperation(operation: NSOperation) {
        
        if let op = operation as? Operation {
            
            if let exclusiveOperation = op as? CustomExclusiveOperation {
                
                let exclusiveConditions = exclusiveOperation.customExclusiveConditions
                
                for condition in exclusiveConditions {
                    let identifier = condition.exclusivityIdentifier
                    
                    let dependency: NSOperation = condition.dependencyForOperation(op) ?? op
                    customExclusivityManager.addOperation(dependency, identifier: identifier)
                }
            }
        }
        
        super.addOperation(operation)
    }
}