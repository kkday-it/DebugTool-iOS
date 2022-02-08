//
//  DebugNodes.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import Foundation

/*
 
 Node("name", [
    Node(),
    Node(),
    Node()
 ])
 
 */
//MARK: Node
public class BaseDebugNode {
    var _name : String = ""
    var _subNodes : [BaseDebugNode] = []
    weak var parentNode : BaseDebugNode? = nil
    public init(name : String, subNodes:[BaseDebugNode]) {
        _name = name
        _subNodes = subNodes
        for subNode in subNodes {
            subNode.parentNode = self
        }
    }
    private var _hasFilled : Bool = false
    /*
     口｜ 口  ｜口
     口｜Back |口    <-- must have back button in the middle
     口｜blank|blank <-- fill out with blank
     */
    func fillSubNodesIfNeeded(close : @escaping ()->Void, backButtonClick : @escaping ()->Void) {
        guard _hasFilled == false else {return}
        var newRootNodes = _subNodes
        let requiredBlankCount = 8 - newRootNodes.count
        if newRootNodes.count > 8 {
            newRootNodes = Array(newRootNodes[0...7])
        }else if requiredBlankCount > 0 {
            for _ in 0..<requiredBlankCount {
                newRootNodes.append(BlankDebugNode())
            }
        }
        //must be 8 nodes
        let middleNode = ReserveActionDebugNode(name: "back", action: {
            backButtonClick()
        })
        newRootNodes = Array(newRootNodes[0...3])+[middleNode]+Array(newRootNodes[4...7])
        _subNodes = newRootNodes
        _hasFilled = true
    }
}
class BlankDebugNode : BaseDebugNode {
    init() {
        super.init(name: "", subNodes: [])
    }
}
class ReserveActionDebugNode : BaseDebugNode {
    var nodeAction : ()->Void = {}
    init(name: String, action: (()->Void)?) {
        super.init(name: name, subNodes: [])
        guard let newAction = action else {return}
        nodeAction = newAction
    }
}
public class ActionDebugNode : BaseDebugNode {
    var nodeAction : ()->Void = {}
    public init(name: String, action: (()->Void)?) {
        super.init(name: name, subNodes: [])
        guard let newAction = action else {return}
        nodeAction = newAction
    }
}
