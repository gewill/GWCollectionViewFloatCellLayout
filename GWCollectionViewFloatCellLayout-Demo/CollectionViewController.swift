//
//  CollectionViewController.swift
//  GWCollectionViewFloatCellLayout
//
//  Created by Will on 2/10/17.
//  Copyright © 2017 Will. All rights reserved.
//

import UIKit
import GWCollectionViewFloatCellLayout

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var layout: GWCollectionViewFloatCellLayout!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Flow layout", style: .plain, target: self, action: #selector(self.flowLayoutButtonClick(_:)))

        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")

        self.collectionView.backgroundColor = .lightGray

        let sectionWidth = UIScreen.main.bounds.width
        self.layout.floatItemSize = CGSize(width: sectionWidth, height: 20)
        self.layout.itemSize = CGSize(width: sectionWidth / 6, height: 40)
        self.layout.headerReferenceSize = CGSize(width: sectionWidth, height: 50)
        self.layout.footerReferenceSize = CGSize(width: sectionWidth, height: 50)

        self.layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        self.layout.minimumLineSpacing = 2
        self.layout.minimumInteritemSpacing = 4
    }


    // MARK - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if indexPath.item == 0 {
            cell.backgroundColor = .yellow
            cell.titleLabel.text = "Float Cell, S\(indexPath.section)"
        } else {
            cell.titleLabel.text = "S\(indexPath.section)-I\(indexPath.item)"

            if indexPath.item % 2 != 0 {
                cell.backgroundColor = UIColor(white: 242 / 255.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            if indexPath.section % 2 != 0 {
                view.backgroundColor = .red
            } else {
                view.backgroundColor = .green
            }
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            if indexPath.section % 2 != 0 {
                view.backgroundColor = .blue
            } else {
                view.backgroundColor = .black
            }
            return view
        }
    }


    // MARK: - UIScroolViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("\(#function) contentOffset: \(scrollView.contentOffset)")
    }

    // MARK: - response methods
    func flowLayoutButtonClick(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "main", bundle: nil).instantiateInitialViewController()!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

