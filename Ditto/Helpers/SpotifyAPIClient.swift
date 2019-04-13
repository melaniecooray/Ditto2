//
//  SpotifyAPIClient.swift
//  Ditto
//
//  Created by Sam Lee on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

//import Foundation
//import Alamofire
//import SwiftyJSON
//
//class SpotifyAPIClient {
//    //These are where we will store all of the authentication information. Get these from your account at developer.lufthansa.com.
//    static let clientSecret = "b761df3a1be84a17b8674ad618699b7b" //FIXME
//    static let clientID = "c5533d8484d548359b9debaf99f66073" //FIXME
//    
//    //This variable will store the session's auth token that we will get from getAuthToken()
//    
//    static func getSearchedSongs( _: ()){
//        
//        //Request URL and authentication parameters
//        let requestURL = "https://api.spotify.com/v1/me/tracks?offset=0&limit=50" //FIXME
//        let parameters: HTTPHeaders = ["Accept":"application/json", "Content-Type":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
//        
//        //print("PARAMETERS FOR REQUEST:")
//        //print(parameters)
//        //print("\n")
//        
//        //GET RID OF THIS
//        //completion(Flight())
//        
//        AF.request(requestURL, headers: parameters).responseJSON { response in
//            //Makes sure that response is valid
//            guard response.result.
//            guard response.result.
//            guard response.result.isSuccess else {
//                print(response.result.error.debugDescription)
//                return
//            }
//            //Creates JSON object
//            let json = JSON(response.result.value) //FIXME
//            print(json)
//            //Create new flight model and populate data
//            let flight = Flight(data: json) //FIXME
//            completion(flight)
//        }
//    }
//}
