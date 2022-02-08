//
//  DebugPanelGridCell.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import UIKit

class DebugPanelGridCell : UICollectionViewCell {
    let label : UILabel = {
        let lbl = UILabel()
        lbl.isUserInteractionEnabled = true
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 10)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setTitle(_ title : String)
    {
        label.text = title
    }
    private func setup() {
        contentView.layer.borderWidth=1
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
