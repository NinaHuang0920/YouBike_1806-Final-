//
//  Service.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/15.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import Foundation

var mapNetworkCheck: Bool = true {
    didSet {
        if mapNetworkCheck == false {
            print("mapNetworkCheck == false,網路沒開")
        } else if mapNetworkCheck == true {
            print("mapNetworkCheck == true,網路已重新開啟")
        }
    }
}

let taoyuanWebString = "https://data.tycg.gov.tw/api/v1/rest/datastore/a1b4714b-3b75-4ff8-a8f2-cc377e4eaa0f?format=json&limit=1000"
//let newTaipeiCityWebString = "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000352-001"

class NetworkService {
    
    private init() {}
    static let sharedInstance = NetworkService()
    
    func fetchJsonData(urlString: String ,completion: @escaping ([StationInfo]?, Error?) -> ()) {

        guard let url = URL(string: urlString) else {
           print("Apologies, something went wrong. Please try again latter...(網址錯誤)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            guard error == nil else { return completion(nil, error) }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                debugPrint()
                print("NETWORK FAIL(網路沒開/網址錯誤)",error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    debugPrint()
                    return print("Status code was not 200")
                }
            }
            guard let data = data else { return completion(nil, error) }
            
            do {
                let json = try JSONDecoder().decode(Top.self, from: data)
                DispatchQueue.main.async {
                    completion(json.result.records, nil)
                }
            } catch let jsonErr {
                debugPrint()
                print("Failed to decode json:", jsonErr.localizedDescription)
            }
            
        }.resume()
    }
}
