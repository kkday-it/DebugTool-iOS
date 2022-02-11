# DebugTool

[![CI Status](https://img.shields.io/travis/daniellee/DebugTool.svg?style=flat)](https://travis-ci.org/daniellee/DebugTool)
[![Version](https://img.shields.io/cocoapods/v/DebugTool.svg?style=flat)](https://cocoapods.org/pods/DebugTool)
[![License](https://img.shields.io/cocoapods/l/DebugTool.svg?style=flat)](https://cocoapods.org/pods/DebugTool)
[![Platform](https://img.shields.io/cocoapods/p/DebugTool.svg?style=flat)](https://cocoapods.org/pods/DebugTool)

# Architecture
![image](https://github.com/kkday-it/DebugTool-iOS/blob/master/pdArchitect-DebugToolArchitect.png)

`DebugPanelGridContainer` for popup animation and gesture handles.

`DebugPanelGridView` holds node models.

`DebugPanelGridModel` controls nodes structure.

`BaseDebugNode` is `Public`, and it's for directory node.

`ActionDebugNode` is `Public`, and it's for action node.

`BlankDebugNode` and `ReserveDebugNode` is for private used.

`kkGesture` is a DSL for convenience using gesture event on UIView.
```swift
let ball = UIView()
ball.kkGesture.click {[weak self] in
            self?.close()
        };
ball.kkGesture.addDragGesture()
```

``kkAnimation`` is a DSL for convenience using animation on CALayer.
```swift
UIView().layer.kkAnimator
            .easeOut(duration: 0.3)
            .changeBounds(CGRect(x: self.buttonContainer.layer.bounds.origin.x, y: self.buttonContainer.layer.bounds.origin.y, width: 20, height: 20))
            .changeBackgroundColor(.gray.withAlphaComponent(0.1))
            .complete { position in
                if position == .end {
                    complete()
                    print("end")
                }
            }.start()
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Find a proper lifeCycle --> declare the structure you need -->  toggle on window.

```swift
DebugNodeConfigs.debugNodes = [
    ActionDebugNode(name: "路由測試", action: {
        //do route!
    }),
    BaseDebugNode(name: "埋點測試", subNodes: [
        ActionDebugNode(name: "action", action: {
            print("action!")
        })
    ]),
    BaseDebugNode(name: "網路測試", subNodes: [
        ActionDebugNode(name: "action2", action: {
            print("action2!")
        })
    ])
]
DebugBall().toggle(on: UIApplication.shared.windows.first!)
```

## Requirements

## Installation

DebugTool is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DebugTool'
```

## Author

daniellee, daniel.lee@kkday.com

## License

DebugTool is available under the MIT license. See the LICENSE file for more info.
