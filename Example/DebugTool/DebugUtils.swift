//
//  DebugUtils.swift
//  DebugTool_Example
//
//  Created by KKday on 2022/2/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import DebugTool

class DebugUtils {
    static func setup() {
        configDebugBall()
    }
    static func configDebugBall() {
        DebugNodeConfigs.debugNodes = [
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
        if let mainWindow = UIApplication.shared.delegate?.window as? UIWindow {
            DebugBall().toggle(on: mainWindow)
        }
    }
}
