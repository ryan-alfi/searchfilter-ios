//
//  ProductViewController.swift
//  SearchFilter
//
//  Created by Ari Fajrianda Alfi on 12/11/19.
//  Copyright © 2019 Ryan Alfi. All rights reserved.
//

import UIKit
import RxSwift

class ProductViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    private let viewModel = ReactiveProductListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        title = "Search"
        
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        _ = filterButton.rx.tap.subscribe({ _ in
            self.filterButtonTapped()
        })
    }
    
    private func setupViewModel() {
        let input = ReactiveProductListViewModel
            .Input(didLoadTrigger: .just(()), didTapCellTrigger: collectionView.rx.itemSelected.asDriver(), pullToRefreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.productListDataCell
            .drive(collectionView.rx.items(cellIdentifier: ProductCollectionViewCell.reuseIdentifier, cellType: ProductCollectionViewCell.self)) { row, model, cell in
                cell.configureCell(with: model)
            }
            .disposed(by: disposeBag)
        
        output.errorData
            .drive(onNext: { errorMessage in
                print("Error", errorMessage)
            })
            .disposed(by: disposeBag)
        
        output.selectedIndex.drive(onNext: { (index, model) in
            if let url = URL(string: model.url),
                    UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:])
            }
        })
        .disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func filterButtonTapped() {
        print("Filter Button Tapped")
    }
    
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 50) / 2
        return CGSize(width: cellWidth, height: cellWidth + 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    }
}
