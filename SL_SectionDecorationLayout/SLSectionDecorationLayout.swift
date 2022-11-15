//
//  SLSectionDecorationLayout.swift
//  SL_SectionDecorationLayout
//
//  Created by 宋亮 on 2022/11/15.
//

import UIKit

protocol SLSectionDecorationLayoutDelegate: NSObjectProtocol {
    /// 指定section点击View
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - collectionViewLayout: layout
    ///   - section: section
    /// - Returns: UIView
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SLSectionDecorationLayout,
                        decorationTapViewForSectionAt section: Int) -> UIView
    
}

extension SLSectionDecorationLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SLSectionDecorationLayout,
                        decorationTapViewForSectionAt section: Int) -> UIView{
        return UIView()
    }
}

class SLSectionDecorationLayout: UICollectionViewFlowLayout {
    weak var decorationDelegate: SLSectionDecorationLayoutDelegate?
    
    // 保存所有自定义的section背景的布局属性
    private var decorationBackgroundAttrs: [Int:UICollectionViewLayoutAttributes] = [:]
    
    // MARK: - View Life Cycle
    override init() {
        super.init()
        // 背景View注册
        self.register(SLSectionBackgroundReusableView.self, forDecorationViewOfKind: SLSectionBackgroundReusableView.BACKGAROUND_CID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 布局配置数据
    override func prepare() {
        super.prepare()
        // 如果collectionView当前没有分区，则直接退出
        guard let numberOfSections = self.collectionView?.numberOfSections else { return }
        
        // 不存在cardDecorationDelegate就退出
        guard let delegate = decorationDelegate else { return }
        
        if decorationBackgroundAttrs.count > 0 {
            decorationBackgroundAttrs.removeAll()
        }
        
        for section:Int in 0..<numberOfSections {
            // 获取该section下第一个，以及最后一个item的布局属性
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at:
                    IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at:
                    IndexPath(item: numberOfItems - 1, section: section))
                else {
                    continue
            }
            var sectionInset:UIEdgeInsets = self.sectionInset
            /// 获取该section的内边距
            let inset:UIEdgeInsets = .zero
            if !(inset == .zero) {
                sectionInset = inset
            }
            
            /// 获取该section header的size
            let headerSize: CGSize = .zero
            var sectionFrame:CGRect = .zero
            if self.scrollDirection == .horizontal {
                let hx = (firstItem.frame.origin.x) - headerSize.width + sectionInset.left
                let hy = (firstItem.frame.origin.y) + sectionInset.top
                let hw = ((lastItem.frame.origin.x) + (lastItem.frame.size.width)) - sectionInset.right
                let hh = ((lastItem.frame.origin.y) + (lastItem.frame.size.height)) - sectionInset.bottom
                sectionFrame = CGRect(x:  hx , y: hy, width: hw, height: hh)
                sectionFrame.origin.y = sectionInset.top
                sectionFrame.size.width = sectionFrame.size.width-sectionFrame.origin.x
                sectionFrame.size.height = self.collectionView!.frame.size.height - sectionInset.top - sectionInset.bottom
                
            } else {
                let vx = (firstItem.frame.origin.x)
                let vy = (firstItem.frame.origin.y) - headerSize.height + sectionInset.top
                let vw = ((lastItem.frame.origin.x) + (lastItem.frame.size.width))
                let vh = ( (lastItem.frame.origin.y) + (lastItem.frame.size.height) ) - sectionInset.bottom
                sectionFrame = CGRect(x:  vx , y: vy, width: vw, height: vh + 10)
                sectionFrame.origin.x = sectionInset.left
                sectionFrame.size.width = (self.collectionView?.frame.size.width)! - sectionInset.left - sectionInset.right
                sectionFrame.size.height = sectionFrame.size.height - sectionFrame.origin.y
            }
            
            let attrs = SLSectionDecorationViewCollectionViewLayoutAttributes(forDecorationViewOfKind: SLSectionBackgroundReusableView.BACKGAROUND_CID, with: IndexPath(item: 0, section: section))
            attrs.frame = sectionFrame
            attrs.zIndex = -1
            
            attrs.tapView = delegate.collectionView(self.collectionView!, layout: self, decorationTapViewForSectionAt: section)
            
            // 将该section的布局属性保存起来
            self.decorationBackgroundAttrs[section] = attrs
        }
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        if elementKind  == SLSectionBackgroundReusableView.BACKGAROUND_CID {
            return self.decorationBackgroundAttrs[section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind,
                                                       at: indexPath)
    }

    // 返回rect范围下父类的所有元素的布局属性以及子类自定义装饰视图的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationBackgroundAttrs.values.filter {
            return rect.intersects($0.frame)
        })
        return attrs
    }
}
