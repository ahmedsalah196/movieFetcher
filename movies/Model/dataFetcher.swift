//
//  dataFetcher.swift
//  movies
//
//  Created by Ahmed Salah on 12/18/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

var usedURl: String = "http://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c53e6604e4985b6989e2&page="
struct websiteResult:Decodable{
    let page:Int
    let total_results:Int
    let total_pages:Int
    let results:[movie]
}

public struct movie: Decodable
{
    let title:String
    let release_date:String
    let overview:String
    let poster_path : String?
}
class dataFetcher {
    var pageToFetch:Int = 1
    var CurMovies: [MovieWithPic] = []
    var tablecontroller: moviesTableViewController!
    var lastURL: URL!
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    init( tablecontroller: moviesTableViewController){
        self.tablecontroller = tablecontroller
    }
    
    func fetch(sessionURL:URL, callback: @escaping completeClosure){
        URLSession.shared.dataTask(with: sessionURL){
            (data,respone,err) in
            guard let data = data else{ return }
            let decoded = self.decode(data: data)
            let imagesfetched = self.toMoviewithPic(fetched: decoded)
            self.tablecontroller.dataFetched(fetched: imagesfetched)
            self.CurMovies = self.CurMovies + imagesfetched
            callback(data, err)
        }.resume()
    }
    
    
    func toMoviewithPic(fetched: [movie])-> [MovieWithPic]{
        var toBereturned: [MovieWithPic] = []
        for m in fetched {
            toBereturned.append(MovieWithPic(movie: m))
        }
        return toBereturned
    }
    
    //decode from data to struuc of movies form
    func decode(data: Data)-> [movie]{
        var retData: Array<movie> = []
        do
        {
            let websiteData = try JSONDecoder().decode(websiteResult.self, from: data)
            retData=websiteData.results
        }
        catch let jsonerr{
            print(jsonerr)
        }
        return retData
    }

    
    
    func getNewData(){
        guard let sessionURL = URL(string: usedURl+String(pageToFetch))
            else { return }
        fetch(sessionURL: sessionURL){
            (data, error) in
            if let err = error {
                print(err)
            }
        }
        pageToFetch = pageToFetch + 1
    }
}
