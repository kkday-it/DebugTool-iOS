//
//  CALayer+kkAnimation.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import UIKit

extension CALayer {
    var kkAnimator : KKCALayerAnimator {
        get { KKCALayerAnimator(self) }
    }
}

class KKCALayerAnimator : DSLBase<CALayer> {
    private var _animator : UIViewPropertyAnimator?
    //MARK: Initals
    func easeOut(duration : TimeInterval)->KKCALayerAnimator {
        _animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        return self
    }
    func easeIn(duration : TimeInterval)->KKCALayerAnimator {
        _animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        return self
    }
    func linear(duration : TimeInterval)->KKCALayerAnimator {
        _animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        return self
    }
    
    //MARK: Actions
    func changeBounds(_ newBounds : CGRect)->KKCALayerAnimator {
        _animator?.addAnimations {[weak self] in
            self?._solver?.bounds = newBounds
        }
        return self
    }
    func changeBackgroundColor(_ newColor : UIColor)->KKCALayerAnimator {
        _animator?.addAnimations {[weak self] in
            self?._solver?.backgroundColor = newColor.cgColor
        }
        return self
    }
    func complete(_ complete : @escaping (UIViewAnimatingPosition)->Void)->KKCALayerAnimator{
        _animator?.addCompletion({ [weak self]position in
            if position == .end {
                complete(position)
                self?._animator = nil
            }
        })
        return self
    }
    func start() {
        _animator?.startAnimation()
    }
}
