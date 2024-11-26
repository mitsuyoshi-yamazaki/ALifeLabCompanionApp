//
//  ViewerCollectionViewController.swift
//  ALifeLabCompanionApp
//
//  Created by Yamazaki Mitsuyoshi on 2024/11/25.
//

import UIKit

private let reuseIdentifier = "ImageCell"

final class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

final class ViewerCollectionViewController: UICollectionViewController {
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!

    private var imageUrls: [URL] = [] {
        didSet {
            if oldValue != imageUrls {
                collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadImagePaths()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let columnCount = 3
        let cellSize = ((view.frame.width + flowLayout.minimumInteritemSpacing) / CGFloat(columnCount)) - flowLayout.minimumInteritemSpacing
        if flowLayout.itemSize.width != cellSize {
            flowLayout.itemSize = .init(width: cellSize, height: cellSize)
            collectionView.reloadData()
        }
    }

    private func reloadImagePaths() {
        let fileManager = FileManager.default
        guard let documentDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        guard let contents = try? fileManager.contentsOfDirectory(at: documentDirectoryUrl, includingPropertiesForKeys: nil, options: []) else {
            return
        }

        imageUrls = contents.filter { $0.pathExtension == "png" }
    }
}

extension ViewerCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        let imageUrl = imageUrls[indexPath.row]

        cell.imageView.image = UIImage(contentsOfFile: imageUrl.path)
        cell.layer.cornerRadius = 4.0
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor

        return cell
    }
}

extension ViewerCollectionViewController {
}
