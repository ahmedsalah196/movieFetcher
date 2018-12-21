//
//  moviesTableViewController.swift
//  movies
//
//  Created by Ahmed Salah on 12/18/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class moviesTableViewController: UITableViewController {
    var indexToAllmovies = 1
    var indexToMyMovies = 0
    var clickedIndex = -1
    var clickedSection = -1
    var twoDimensionalMovies: [[MovieWithPic]] = [[],[]]
    var isExpanable = [
        true,
        true
    ]
    var fetcher : dataFetcher!
    var names = [
        "My Movies",
        "All Movies"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher = dataFetcher(tablecontroller: self)
    }
    
    //responsible for showing the popup as a subview when the user wants to add his own movie
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "titleID") as! titleAndDateViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.tablecontroller = self
        self.view.isAccessibilityElement = false
        popOverVC.didMove(toParentViewController: self)
    }
    
    //called when data is fetched by the data fetcher
    func dataFetched(fetched: [MovieWithPic]){
        var indexPaths: [IndexPath] = []
        let countOfIndicesInTable = twoDimensionalMovies[indexToAllmovies].count
        for x in fetched.indices {
            let index = IndexPath(row: x + countOfIndicesInTable, section: indexToAllmovies)
            indexPaths.append(index)
        }
        twoDimensionalMovies[indexToAllmovies].append(contentsOf: fetched)
        if isExpanable[indexToAllmovies]
        {
            DispatchQueue.main.async {
                self.tableView.insertRows(at: indexPaths, with: .fade)
            }
        }
    }
    
    //called by popup controller when all info are extracted from the user to be added to the list
    func addUserMovie(movie: MovieWithPic)
    {
        let index = twoDimensionalMovies[indexToMyMovies].count
        twoDimensionalMovies[indexToMyMovies].append(movie)
        let indexPath = IndexPath(row: index, section: indexToMyMovies)
        if isExpanable[indexToMyMovies]
        {
            DispatchQueue.main.async {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        }
    }

    //buttons are used to add listener responsible for expanding and closing thee section by
    // clicking on the section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button=UIButton(type: .system)
        button.setTitle(names[section], for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .orange
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.accessibilityIdentifier = names[section]
        button.addTarget(self, action: #selector(ExpandCloseSection), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    
    @objc func ExpandCloseSection(button: UIButton){
        let section = button.tag
        let indexpaths=allIndices(section: section)
        
        //toggling the boolean
        isExpanable[section] = !isExpanable[section]
        
        //decide to expand or close upon current state
        operationToBeDone(isExpanded: isExpanable[section], indexpaths: indexpaths)
    }
    
    //get all rows in selected section
    func allIndices(section: Int)-> [IndexPath]{
        var indexpaths=[IndexPath]()
        for row in twoDimensionalMovies[section].indices{
            let indexPath = IndexPath(row: row, section: section)
            indexpaths.append(indexPath)
        }
        if section == indexToAllmovies {
            let indexpath = IndexPath(row: twoDimensionalMovies[indexToAllmovies].count, section: indexToAllmovies)
            indexpaths.append(indexpath)
        }
        return indexpaths
    }
    
    
    func operationToBeDone(isExpanded: Bool, indexpaths: [IndexPath]){
        if isExpanded{
            tableView.insertRows(at: indexpaths, with: .fade)
        }
        else {
            tableView.deleteRows(at: indexpaths, with: .fade)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalMovies.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //specify number based on it expansion state
        if isExpanable[section]{
            //if all movies section we need an additional row for the loading cell
            return twoDimensionalMovies[section].count + ((section==indexToAllmovies) ? 1 : 0)
        }
            return 0
    }

    // specify which type of cells to be shown on this row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if row == twoDimensionalMovies[indexToAllmovies].count , section == indexToAllmovies {
            fetcher.getNewData()
            return createLoadingCell()
        }
        let currentMovie: MovieWithPic = twoDimensionalMovies[section][row]
        if row == clickedIndex , section == clickedSection
        {
            return createDetailsViewCell(selectedMovie: currentMovie)
        }
        else {
            return createAbstractTableViewCell(currentMovie: currentMovie)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ind: Int = indexPath.row
        var pre: IndexPath?
        
        //if it was selected for details so diselect
        if clickedIndex == ind , clickedSection  == indexPath.section{
            clickedIndex = -1
            clickedSection = -1
        }
            //expand
        else {
            if clickedIndex != -1 , isExpanable[clickedSection]
            {
                pre = IndexPath(row: clickedIndex, section: clickedSection)
            }
            clickedIndex = ind
            clickedSection = indexPath.section
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        // if there was another cell in details mode change it to abstract mode
        // this allows only one cell to be in details mode
        if let pre = pre {
            tableView.reloadRows(at: [pre], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        guard editingStyle == .delete , section == indexToMyMovies else {return}
        
        // if it was details cell-> reset indices
        if section == clickedSection , row == clickedIndex {
            clickedIndex = -1
            clickedSection = -1
        }
        // all cell after the cell to be deleted will be shifted by one cell to up
        // we need to reset the cell of details view index if it was among these cells
        if section == clickedSection , clickedIndex > row {
            clickedIndex = clickedIndex - 1
        }
        twoDimensionalMovies[section].remove(at: row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // return custom loading cell
    func createLoadingCell()->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "indicator") as! loadingTableViewCell
        return cell
    }
    
    // return custom details cell
    func createDetailsViewCell(selectedMovie: MovieWithPic)-> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: "details") as! deatailsTableViewCell
        cell.setCell(title: selectedMovie.title, date: selectedMovie.date, text:selectedMovie.overview, image: selectedMovie.image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

    // return custom abstract cell
    func createAbstractTableViewCell(currentMovie: MovieWithPic)-> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: "abstract") as!abstractTableViewCell
        cell.setCell(title: currentMovie.title, date: currentMovie.date, image: currentMovie.image)
        return cell
    }
    
    // display cell animation
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }
}
