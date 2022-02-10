//
//  UIView+kkGesture.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import UIKit

extension UIView {
    public var kkGesture : KKGesture {
        get { KKGesture(self) }
    }
}

public class WrappedTapGesture : UITapGestureRecognizer {
    let _action : ()->Void
    init(_ action : @escaping ()->Void) {
        _action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(handleClick(_:)))
    }
    @objc func handleClick(_ gesture : UITapGestureRecognizer) {
        _action()
    }
}

public class CleanGestureHandler : NSObject, UIGestureRecognizerDelegate {
    public let targetTag = 8080
    weak var _gesture : UIGestureRecognizer?
    
    func registReserveView(view:UIView) {
        view.tag = targetTag
    }
    
    func cleanGesture(gesture : UIGestureRecognizer) {
        _gesture = gesture
        _gesture?.delegate = self
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // don't response if not target view
        if (touch.view?.tag == targetTag) {return true}
        return false
    }
}

public class KKGesture : DSLBase<UIView> {
    //MARK: Click
    private static let cleanGestureHandler = CleanGestureHandler()
    public func click(_ action : @escaping ()->Void) {
        guard let targetView = _solver else {return}
        KKGesture.cleanGestureHandler.registReserveView(view: targetView)//mark
        let gesture = WrappedTapGesture {
            action()
        }
        KKGesture.cleanGestureHandler.cleanGesture(gesture: gesture)//clean
        targetView.addGestureRecognizer(gesture)
    }
    
    //MARK: Drag
    public func addDragGesture() {
        let panGes = UIPanGestureRecognizer(target: KKGesture.self, action: #selector(KKGesture._drag_handlePan(_:)))
        _solver?.addGestureRecognizer(panGes)
    }
    
    @objc private static func _drag_handlePan(_ gesture: UIPanGestureRecognizer) {
        if (gesture.state == .changed) {
            guard let targetView = gesture.view else {return}
            let translation = gesture.translation(in: targetView)
            var center = targetView.center
            center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
            targetView.center = correctPointWithBound(center)
            gesture.setTranslation(.zero, in: targetView)
        }
    }
    /** Check has out of screen */
    private static func correctPointWithBound(_ point : CGPoint)->CGPoint {
        var _point = point
        if (_point.x < 0) {
            _point.x = 0
        }else if (_point.x > UIScreen.main.bounds.width) {
            _point.x = UIScreen.main.bounds.width
        }
        var safeAreaTop : CGFloat = 0, safeAreaBottom : CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaTop = UIApplication.shared.debugtool_getMainWindow()?.safeAreaInsets.top ?? 0
            safeAreaBottom = UIApplication.shared.debugtool_getMainWindow()?.safeAreaInsets.bottom ?? 0
        }
        if (_point.y < safeAreaTop) {
            _point.y = safeAreaTop
        }else if (_point.y > UIScreen.main.bounds.height - safeAreaBottom ) {
            _point.y = UIScreen.main.bounds.height - safeAreaBottom
        }
        return _point
    }
}

extension UIApplication {
    static var debugtool_mainWindowKey = "debugtool_mainWindowKey"
    func debugtool_setMainWindow(keyWindow:UIWindow) {
        objc_setAssociatedObject(self, &(UIApplication.debugtool_mainWindowKey), keyWindow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func debugtool_getMainWindow()->UIWindow? {
        return objc_getAssociatedObject(self, &(UIApplication.debugtool_mainWindowKey)) as? UIWindow
    }
    
    func debugtool_toggleView(_ view : UIView) {
        if let mainWindow = UIApplication.shared.debugtool_getMainWindow() { mainWindow.addSubview(view) }
    }
}
