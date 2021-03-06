//
//  ViewController.swift
//  DebugTool
//
//  Created by daniellee on 02/08/2022.
//  Copyright (c) 2022 daniellee. All rights reserved.
//

import UIKit
import DebugTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

