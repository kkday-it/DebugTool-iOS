//
//  DSLBase_NSObject.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import Foundation

public class DSLBase<T:NSObject> {
    weak public var _solver : T?
    init(_ solver : T) {
        _solver = solver
    }
}
