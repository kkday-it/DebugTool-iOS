//
//  DebugPanelGridContainer.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import UIKit

class DebugPanelGridContainer : UIView {
    let buttonContainer : UIView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-10, y: UIScreen.main.bounds.size.height/2-10,width: 20,height: 20))
    var _gridView : DebugPanelGridView?
    var _cloneNodes : [BaseDebugNode] = []
    
    init(nodes : [BaseDebugNode]) {
        super.init(frame: UIScreen.main.bounds)
        configBG()
        self.addSubview(buttonContainer)
        // to avoid status been left over
        _cloneNodes = copyNodes(nodes: nodes)
        configGridView(nodes: _cloneNodes)
    }
    
    func copyNodes(nodes : [BaseDebugNode])->[BaseDebugNode] {
        var duplicateNodes : [BaseDebugNode] = []
        for node in nodes {
            if let actionNode = node as? ActionDebugNode {
                let newActionNode = ActionDebugNode(name: node._name, action: actionNode.nodeAction)
                duplicateNodes.append(newActionNode)
            }else {
                let newNode = BaseDebugNode(name: node._name, subNodes: copyNodes(nodes: node._subNodes))
                duplicateNodes.append(newNode)
            }
        }
        return duplicateNodes
    }
    
    func configGridView(nodes : [BaseDebugNode]) {
        let gridView = DebugPanelGridView(rootNodes: nodes) {[weak self] in
            self?.close()
        }
        gridView.alpha = 0
        self.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            gridView.widthAnchor.constraint(equalToConstant: 200),
            gridView.heightAnchor.constraint(equalToConstant: 200),
            gridView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gridView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        _gridView = gridView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configBG() {
        self.backgroundColor = .lightGray.withAlphaComponent(0.2)
        self.kkGesture.click {[weak self] in
            self?.close()
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointInGridView = convert(point, to: _gridView)
        if _gridView?.point(inside: pointInGridView, with: event) ?? false {
            return _gridView?.hitTest(pointInGridView, with: event)
        }
        return super.hitTest(point, with: event)
    }
    
    //MARK: - Actions
    func open() {
        UIApplication.shared.debugtool_toggleView(self)
        openAnimation()
    }
    
    func close() {
        closeAnimation(){[weak self] in
            self?.removeFromSuperview()
        }
    }
    //MARK: - Animations
    private func openAnimation(complete: (()->Void)? = nil) {
        self.buttonContainer.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        self.buttonContainer.layer.kkAnimator.easeOut(duration: 0.3)
            .changeBounds(CGRect(x: self.buttonContainer.layer.bounds.origin.x, y: self.buttonContainer.layer.bounds.origin.y, width: 200, height: 200))
            .changeBackgroundColor(.gray.withAlphaComponent(1))
            .complete { [weak self]position in
                if position == .end {
                    self?._gridView?.alpha = 1
                    complete?()
                    print("end")
                }
            }.start()
    }
    
    private func closeAnimation(complete: (()->Void)? = nil) {
        self._gridView?.alpha = 0
        self.buttonContainer.layer.backgroundColor = UIColor.gray.withAlphaComponent(1).cgColor
        self.buttonContainer.layer.kkAnimator
            .easeOut(duration: 0.3)
            .changeBounds(CGRect(x: self.buttonContainer.layer.bounds.origin.x, y: self.buttonContainer.layer.bounds.origin.y, width: 20, height: 20))
            .changeBackgroundColor(.gray.withAlphaComponent(0.1))
            .complete { position in
                if position == .end {
                    complete?()
                    print("end")
                }
            }.start()
    }
}
