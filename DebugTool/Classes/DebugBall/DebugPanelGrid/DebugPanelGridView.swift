//
//  DebugPanelGridView.swift
//  DebugTool
//
//  Created by KKday on 2022/2/6.
//

import UIKit
class DebugPanelGridView : UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var nodeModel : DebugPanelGridModel
    var _closeAction : ()->Void = {}
    var _collectionView : UICollectionView?
    
    init(rootNodes : [BaseDebugNode], closeAction : @escaping ()->Void) {
        _closeAction = closeAction
        nodeModel = DebugPanelGridModel(rootNodes: rootNodes)
        super.init(frame: .zero)
        nodeModel.listen {
            closeAction()
        } updateViewAction: { [weak self] in
            self?.gridViewUpdate()
        }
        configGridView()
    }
    
    func configGridView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray
        collectionView.register(DebugPanelGridCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -25),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -25),
            collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        _collectionView = collectionView
    }
    
    func gridViewUpdate() {
        _collectionView?.reloadData()
    }
    
    //UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let debugCell = cell as? DebugPanelGridCell else {return cell}
        let dataSource = nodeModel.currentNode
        let row = indexPath.row
        guard dataSource._subNodes.count > row else {
            return cell
        }
        let thisNode = dataSource._subNodes[row]
        let title = thisNode._name
        debugCell.setTitle(title)
        return debugCell
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataSource = nodeModel.currentNode
        let row = indexPath.row
        guard dataSource._subNodes.count > row else {
            return
        }
        let thisNode = dataSource._subNodes[row]
        guard !(thisNode is BlankDebugNode) else {return}
        guard let actionNode = thisNode as? ActionDebugNode else{
            //back(reserve) button
            if let reserveActionNode = thisNode as? ReserveActionDebugNode {
                reserveActionNode.nodeAction()
                return
            }
            //base button
            nodeModel.gotoNode(node: thisNode)
            return
        }
        //action button
        actionNode.nodeAction()
        _closeAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
