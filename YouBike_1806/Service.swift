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
//        print("MAP networkCheck Change:", mapNetworkCheck)
        if mapNetworkCheck == false {
//            print(" mapNetworkCheck == false,網路沒開")
            return
        } else if mapNetworkCheck == true {
//            print(" mapNetworkCheck == true,網路已重新開啟")
            return
        }
    }
}

let webString = "https://data.tycg.gov.tw/api/v1/rest/datastore/a1b4714b-3b75-4ff8-a8f2-cc377e4eaa0f?format=json&limit=1000"

var networkCheckFail: Bool? = true {
    didSet {
//        print("networkCheckFail Change:", networkCheckFail!)
    }
}

struct Service {
    static let sharedInstance = Service()
    func fetchJsonData(urlString: String ,completion: @escaping ([BikeStationInfo]?, Error?) -> ()) {

        guard let url = URL(string: urlString) else {
           print("Apologies, something went wrong. Please try again latter...(網址錯誤)")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("NETWORK FAIL(網路沒開/網址錯誤)")
                mapNetworkCheck = false
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                     return print("Status code was not 200")
                }
            }
            guard let data = data else { return }
            guard let json = try? JSONDecoder().decode(Top.self, from: data) else {

                completion(nil, error)
                print("Failed to fetch json...")
                return
            }
            DispatchQueue.main.async {
               completion(json.result.records, nil)
                networkCheckFail = false
            }
        }.resume()
    }
}
