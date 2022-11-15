//
//  SLSectionBackgroundReusableView.swift
//  SL_SectionDecorationLayout
//
//  Created by 宋亮 on 2022/11/15.
//

import UIKit

class SLSectionBackgroundReusableView: UICollectionReusableView {
    static let BACKGAROUND_CID = "BACKGAROUND_CID"
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let att = layoutAttributes as? SLSectionDecorationViewCollectionViewLayoutAttributes else {
            return
        }

        att.tapView.frame = bounds
        addSubview(att.tapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// section装饰背景的布局属性
class SLSectionDecorationViewCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    //装饰背景图
    var tapView = UIView()

    /// 所定义属性的类型需要遵从 NSCopying 协议
    /// - Parameter zone:
    /// - Returns:
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SLSectionDecorationViewCollectionViewLayoutAttributes
        copy.tapView = self.tapView
        return copy
    }
    
    /// 所定义属性的类型还要实现相等判断方法（isEqual）
    /// - Parameter object:
    /// - Returns: 是否相等
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SLSectionDecorationViewCollectionViewLayoutAttributes else {
            return false
        }

        if self.tapView != rhs.tapView {
            return false
        }

        return super.isEqual(object)
    }
}
