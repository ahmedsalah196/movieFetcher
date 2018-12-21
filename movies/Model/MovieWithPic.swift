//
//  MovieWithPic.swift
//  movies
//
//  Created by Ahmed Salah on 12/18/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class MovieWithPic {
    let title:String
    let date:String
    let overview:String
    let image:UIImage
    init(movie: movie) {
        title = movie.title
        self.date = movie.release_date
        overview = movie.overview
        var urlString = "https://image.tmdb.org/t/p/w200"
        if let path = movie.poster_path
            {
                urlString += path
            }
        let url = URL(string: urlString)
        guard let data = try?Data(contentsOf: url!)
            else{image = #imageLiteral(resourceName: "clapper")
                return
        }
        image = UIImage(data: data) ?? #imageLiteral(resourceName: "clapper")
    }
    init(
        title: String,
        date: String,
        overview: String,
        image:UIImage
        )
    {
        self.title = title
        self.date = date
        self.overview = overview
        self.image = image
    }
}
