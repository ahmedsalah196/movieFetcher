//
//  moviesTests.swift
//  moviesTests
//
//  Created by Ahmed Salah on 12/17/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import XCTest
@testable import movies

class moviesTests: XCTestCase {
    var tablecontroller:moviesTableViewController!
    var df:dataFetcher!
    var nazer: movie!
    override func setUp() {
        super.setUp()
        tablecontroller = moviesTableViewController()
        df = dataFetcher(tablecontroller: tablecontroller)
    }
    
    override func tearDown() {
        tablecontroller = nil
        df = nil
        super.tearDown()
    }
    
    func testDFupdatesData() {
        guard let url = URL(string: "http://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c53e6604e4985b6989e2&page=1") else {
            fatalError("URL can't be empty")
        }
        df.fetch(sessionURL: url)  { (success, response) in
            let tabledata = self.tablecontroller.twoDimensionalMovies[indexToAllmovies]
            XCTAssertGreaterThan(tabledata.count, 0)
            let decodedData = self.df.decode(data: success!)
            XCTAssertEqual(tabledata.count,decodedData.count)
            XCTAssertEqual(decodedData[0].title, tabledata[0].title)
            XCTAssertEqual(decodedData.last!.title, tabledata.last!.title)
        }
    }
    
    func testcreatingMovieAndAddingIt(){
        let movie = MovieWithPic(title: "el nazer", date: "2001-1-10", overview: "Comedy", image: #imageLiteral(resourceName: "clapper"))
        let oldtabledata = self.tablecontroller.twoDimensionalMovies[indexToMyMovies]
        tablecontroller.addUserMovie(movie: movie)
        let newTableData = self.tablecontroller.twoDimensionalMovies[indexToMyMovies]
        XCTAssertEqual(oldtabledata.count+1 , newTableData.count)
        XCTAssertEqual(newTableData.last?.title, "el nazer")
    }
    
    func testMovieFetchingPic(){
        
        assertequalImages(path: "null")
        assertequalImages(path: "/kQKcbJ9uYkTQql2R8L4jTUz7l90.jpg")
        
    }
    
    func assertequalImages(path: String, file: StaticString=#file, line: UInt = #line){
        let nazer = movie(title: "el nazer", release_date: "2002-2-20", overview: "comedy", poster_path: path )
        let imageUrl = "https://image.tmdb.org/t/p/w200\(path)"
        let url = URL(string: imageUrl)
        let mwp = MovieWithPic(movie: nazer)
        if let data = try?Data(contentsOf: url!)
        {
            let image = UIImage(data: data)!
            assertSameData(image1: image, image2: mwp.image, file: file, line: line)
        }
        else
        {
            assertSameData(image1: #imageLiteral(resourceName: "clapper"), image2: mwp.image, file: file, line: line)
        }
    }
    
    func assertSameData(image1: UIImage, image2: UIImage, file: StaticString=#file, line: UInt = #line){
        let data1 = UIImageJPEGRepresentation(image1, 1.0)
        let data2 = UIImageJPEGRepresentation(image2, 1.0)
        XCTAssertEqual(data1, data2, file: file, line: line)
    }
    
    func testDFToMovieWthPic(){
        var movies: [movie] = []
         let nazer = movie(title: "el nazer", release_date: "2002-2-20", overview: "comedy", poster_path: nil)
        movies.append(nazer)
        let lemby = movie(title: "el lemby", release_date: "2002-01-03", overview: "Comedy", poster_path: nil)
        movies.append(lemby)

        let moviesWithPics = self.df.toMoviewithPic(fetched: movies)
        XCTAssertEqual(movies.count, moviesWithPics.count)
        XCTAssertEqual(movies.first?.title, moviesWithPics.first?.title)
        XCTAssertEqual(movies.last?.title, moviesWithPics.last?.title)
    }
    
    func testDefaultPicForNil(){
        let lemby = movie(title: "el lemby", release_date: "2002-01-03", overview: "Comedy", poster_path: nil)
        let lembyWithPic = MovieWithPic(movie: lemby)
        assertSameData(image1: lembyWithPic.image, image2: #imageLiteral(resourceName: "clapper"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
