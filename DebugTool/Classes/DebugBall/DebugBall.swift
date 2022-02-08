//
//  DebugBall.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import UIKit

public class DebugBall : UIView {
    var x : CGFloat = 20
    var y : CGFloat = UIScreen.main.bounds.height/2 - 22
    let width : CGFloat = 50, height : CGFloat = 50
    let titlelabel : UILabel = {
        let lbl = UILabel()
        lbl.layer.backgroundColor = UIColor.gray.cgColor
        lbl.alpha = 0.7
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 25
        lbl.text = "D"
        lbl.textColor = .white
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    public func toggle(on window : UIWindow) {
        UIApplication.shared.debugtool_setMainWindow(keyWindow: window)
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        window.addSubview(self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configLabel()
        self.kkGesture.addDragGesture()
        titlelabel.kkGesture.click {
            DebugPanelGridContainer(nodes: DebugNodeConfigs.debugNodes).open()
        }
    }
    private func configLabel() {
        self.addSubview(titlelabel)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            titlelabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            titlelabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            titlelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titlelabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
