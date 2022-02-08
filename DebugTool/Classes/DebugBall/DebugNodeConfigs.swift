//
//  DebugNodeConfigs.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import Foundation

public enum DebugNodeConfigs {
    //at most 8 nodes for each
    public static var debugNodes : [BaseDebugNode] = [
        BaseDebugNode(name: "網路", subNodes: [
            ActionDebugNode(name: "測試1", action: {
                print("測試1")
            })
        ]),
        ActionDebugNode(name: "測試2", action: {
            print("測試2")
        }),
        BaseDebugNode(name: "路由", subNodes: [
            ActionDebugNode(name: "測試1", action: {
                print("測試1")
            })
        ]),
        BaseDebugNode(name: "元件", subNodes: [
            ActionDebugNode(name: "測試1", action: {
                print("測試1")
            })
        ]),
    ]
}


