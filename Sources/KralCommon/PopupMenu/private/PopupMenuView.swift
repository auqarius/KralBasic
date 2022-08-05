//
//  PopupMenuView.swift
//
//  Created by LiKai on 2022/7/29.
//
//
#if canImport(UIKit)

import UIKit

class PopupMenuView: UIView {
    
    var items: [PopupMenuItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var clickedItem: ((PopupMenuItem) -> ())?
    
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = contentInset
        collectionView.register(PopupMenuCell.self, forCellWithReuseIdentifier: PopupMenuCell.string)
        addSubview(collectionView)
        addCollectionViewLayout()
        collectionView.reloadData()
    }
    
    fileprivate func addCollectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let leading = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailling = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraints([leading, trailling, top, bottom])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopupMenuView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopupMenuCell.string, for: indexPath) as! PopupMenuCell
        
        cell.item = items[indexPath.row]
        cell.clicked = { item in
            if let clickedItem = self.clickedItem {
                clickedItem(item)
            }
        }
        
        return cell
    }
    
}

class PopupMenuCell: UICollectionViewCell {
    
    var clicked: ((PopupMenuItem) -> ())?
    
    var item: PopupMenuItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            iconImageView.image = item.iconImage
            if let iconTintColor = item.iconTintColor {
                iconImageView.image = item.iconImage?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = iconTintColor
            }

            titleLabel.font = item.textFont
            titleLabel.textColor = item.textColor
            titleLabel.textAlignment = item.textAlignment
            titleLabel.text = item.title
        }
    }

    fileprivate var iconImageView: UIImageView = UIImageView()
    fileprivate var titleLabel: UILabel = UILabel()
    fileprivate var clickedButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        iconImageView.contentMode = .center
        contentView.addSubview(iconImageView)
        addIconImageViewLayout()
        
        contentView.addSubview(titleLabel)
        addTitleLabelLayout()
        
        clickedButton.layer.cornerRadius = 6
        clickedButton.clipsToBounds = true
        clickedButton.addTarget(self, action: #selector(touchDown(btn:)), for: .touchDown)
        clickedButton.addTarget(self, action: #selector(touchUpInside(btn:)), for: .touchUpInside)
        clickedButton.addTarget(self, action: #selector(touchCancel(btn:)), for: .touchCancel)
        clickedButton.addTarget(self, action: #selector(touchCancel(btn:)), for: .touchUpOutside)

        contentView.addSubview(clickedButton)
        addClickedButtonLayout()
    }
    
    fileprivate func addIconImageViewLayout() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        contentView.addConstraints([centerX, centerY])
    }
    
    fileprivate func addTitleLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let leading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 4)
        let trailling = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -4)
        let height = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 15)
        let bottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -4)
        contentView.addConstraints([leading, trailling, bottom])
        titleLabel.addConstraint(height)
    }
    
    fileprivate func addClickedButtonLayout() {
        clickedButton.translatesAutoresizingMaskIntoConstraints = false

        let leading = NSLayoutConstraint(item: clickedButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailling = NSLayoutConstraint(item: clickedButton, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: clickedButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: clickedButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        contentView.addConstraints([leading, trailling, top, bottom])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func touchDown(btn: UIButton) {
        btn.backgroundColor = UIColor.white.alpha(0.15)
    }
    
    @objc private func touchUpInside(btn: UIButton) {
        btn.backgroundColor = .clear
        if let clicked = clicked,
            let item = item {
            clicked(item)
        }
    }
    
    @objc private func touchCancel(btn: UIButton) {
        btn.backgroundColor = .clear
    }
}

#endif
