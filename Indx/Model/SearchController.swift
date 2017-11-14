//
//  SearchController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation
import AlgoliaSearch


final class SearchController {
    
    typealias ResultType = [String:Any]
    
    // MARK: - properties
    
    private let client = Client(appID: "APP_ID", apiKey: "API_KEY")
    private let index: SearchIndex
    private let resultHandler: ([ResultType]?, Error?) -> ()
    
    private weak var searchOperation: Operation? = nil {
        didSet { oldValue?.cancel() }
    }
    
    // MARK: - init & deinit
    
    init(index: SearchIndex, resultHandler: @escaping ([ResultType]?, Error?) -> ()) {
        
        self.index = index
        self.resultHandler = resultHandler
    }
    
    deinit {
        searchOperation?.cancel()
    }
    
    // MARK: - public methods
    
    func perform(query: SearchQuery) {
        
        let index = client.index(withName: self.index.rawValue)
        index.searchCacheEnabled = true
        
        let algoliaQuery = Query(query: query.text)
        algoliaQuery.page = query.page
        
        searchOperation = index.search(algoliaQuery) { [unowned self] (opJSON, opError) in
            
            switch (opJSON, opError) {
            case (_, .some(let error)):
                self.resultHandler(nil, error)
                
            case (.some(let json), _):
                let hits = json["hits"] as? [JSONObject] ?? []
                self.resultHandler(hits, nil)
                
            default:
                self.resultHandler(nil, NSError(domain: "algolia", code: 414, userInfo: [NSLocalizedDescriptionKey:"Unknown error"]))
            }
        }
    }
}
