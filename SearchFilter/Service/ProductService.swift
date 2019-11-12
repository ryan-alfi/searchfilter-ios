//
//  ProductService.swift
//  SearchFilter
//
//  Created by Ari Fajrianda Alfi on 12/11/19.
//  Copyright © 2019 Ryan Alfi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ProductServiceError: Error {
    case missingData
}

protocol ProductServiceProtocol {
    func reactiveFetchProduct() -> Observable<[Product]>
}

class NetworkProductService: ProductServiceProtocol {
    func reactiveFetchProduct() -> Observable<[Product]> {
        let url = URL(string: "https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=10000&pmax=100000&wholesale=true&official=true&fshop=2&start=0&rows=10")!
        
        let urlRequest = URLRequest(url: url)
        
        let response = URLSession.shared.rx
            .data(request: urlRequest)
            .flatMapLatest { data -> Observable<ProductListResponse> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do{
                    let resultData = try decoder.decode(ProductListResponse.self, from: data)
                    return Observable.just(resultData)
                } catch (let decodeError) {
                    return Observable.error(decodeError)
                }
        }
        
        let products = response.map { $0.data }
        return products
    }
}
