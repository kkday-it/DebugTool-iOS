//
//  DebugPanelGridModel.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import Foundation
class DebugPanelGridModel {
    private(set) var root : BaseDebugNode
    private(set) var currentNode : BaseDebugNode
    private var _closeAction : ()->Void = {}
    private var _updateViewAction : ()->Void = {}
    init(rootNodes : [BaseDebugNode]) {
        //init rootNode
        let userInputNodes = rootNodes
        root = BaseDebugNode(name: "", subNodes: userInputNodes)
        currentNode = root
        fillSubNodeIfNeeded(root)
        //show root node
        _updateViewAction()
    }
    func listen(closeAction : @escaping ()->Void, updateViewAction:@escaping ()->Void) {
        _closeAction = closeAction
        _updateViewAction = updateViewAction
    }
    
    private func fillSubNodeIfNeeded(_ targetNode:BaseDebugNode) {
        targetNode.fillSubNodesIfNeeded(close: {[weak self] in
            self?._closeAction()
        }) { [weak self] in
            //back button clicked
            guard let parent = self?.currentNode.parentNode else {
                self?._closeAction()
                return
            }
            self?.gotoNode(node: parent)
        }
    }
    
    func gotoNode(node : BaseDebugNode) {
        if let actionNode = node as? ActionDebugNode {
            actionNode.nodeAction()
            _closeAction()
        }else {
            //fill out next node
            fillSubNodeIfNeeded(node)
            
            //change current node
            currentNode = node
            
            //transition to node
            _updateViewAction()
            
        }
    }
}
