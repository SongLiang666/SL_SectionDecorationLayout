//
//  ViewController.swift
//  SL_SectionDecorationLayout
//
//  Created by 宋亮 on 2022/11/15.
//

import UIKit

class ViewController: UIViewController {

    lazy var listV: UICollectionView = {
        let layout = SLSectionDecorationLayout()
        layout.decorationDelegate = self
        
        let v = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(v)
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        v.register(SLCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        v.register(SLSectionV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        v.register(SLSectionV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")

        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listV.reloadData()
    }
}


extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(arc4random())%9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SLCollectionViewCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader
        {
            if let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? SLSectionV
            {
                v.backgroundColor = .yellow
                return v
            }
        }
        else if kind == UICollectionView.elementKindSectionFooter
        {
            if let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as? SLSectionV
            {
                v.backgroundColor = .blue
                return v
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击Cell")
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 40)
    }
}

extension ViewController: SLSectionDecorationLayoutDelegate{
    
    @objc private func viewTap(_ sender: UITapGestureRecognizer){
        //跳转动态详情
        guard let tag = sender.view?.tag else { return }
        print("点击第\(tag)个section")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SLSectionDecorationLayout,
                        decorationTapViewForSectionAt section: Int) -> UIView {
        
        let v = UIView()
        v.backgroundColor = .clear
        v.isUserInteractionEnabled = true
        v.tag = section
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTap(_:))))
        return v
    }
}

class SLCollectionViewCell: UICollectionViewCell{
    lazy var backV: UIView = {
        let v = UIView()
        contentView.addSubview(v)
        v.backgroundColor = .orange
        return v
    }()

    override func layoutSubviews() {
        backV.frame = contentView.bounds
    }
}

class SLSectionV: UICollectionReusableView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
