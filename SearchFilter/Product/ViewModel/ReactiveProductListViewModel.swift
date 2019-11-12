//
//  ReactiveProductListViewModel.swift
//  SearchFilter
//
//  Created by Ari Fajrianda Alfi on 12/11/19.
//  Copyright © 2019 Ryan Alfi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReactiveProductListViewModel: ViewModelType {
    let service: ProductServiceProtocol
    
    init(service: ProductServiceProtocol = NetworkProductService()) {
        self.service = service
    }
    
    struct Input {
        let didLoadTrigger: Driver<Void>
        let didTapCellTrigger: Driver<IndexPath>
        let pullToRefreshTrigger: Driver<Void>
    }
    
    struct Output {
        let productListDataCell: Driver<[ProductListCellData]>
        let errorData: Driver<String>
        let selectedIndex: Driver<(index: IndexPath, model: ProductListCellData)>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        let fetchDataTrigger = Driver.merge(input.didLoadTrigger, input.pullToRefreshTrigger)
        
        let fetchData = fetchDataTrigger
            .do(onNext: {
                isLoading.accept(true)
            })
            .flatMapLatest { [service] _ -> Driver<[Product]> in
                service
                    .reactiveFetchProduct()
                    .do(onNext: { _ in
                        isLoading.accept(false)
                    }, onError: { error in
                        errorMessage.onNext(error.localizedDescription)
                    })
                    .asDriver { _ -> Driver<[Product]> in
                        Driver.empty()
                }
        }
        
        let productListCellData = fetchData
            .map { products -> [ProductListCellData] in
                products.map { product -> ProductListCellData in
                    ProductListCellData(image: product.imageUri, name: product.name, url: product.uri, price: product.price)
                }
        }
        
        let errorMessageDriver = errorMessage
            .asDriver { error -> Driver<String> in
                Driver.empty()
        }
        
        let selectedIndexCell = input
            .didTapCellTrigger
            .withLatestFrom(productListCellData) { index,
                contacts -> (index: IndexPath, model: ProductListCellData) in
                return (index: index, model: contacts[index.row])
        }
        
        return Output(productListDataCell: productListCellData, errorData: errorMessageDriver, selectedIndex: selectedIndexCell, isLoading: isLoading.asDriver())
    }
}
