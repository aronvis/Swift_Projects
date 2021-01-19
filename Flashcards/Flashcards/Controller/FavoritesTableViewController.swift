//
//  FavoritesTableViewController.swift
//  Flashcards
//
//  Created by Aron Vischjager on 4/5/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController
{
    // Member Variables
    private var dataModel = FlashcardsModel.sharedInstance
    private var favoriteCards: [Flashcard] = []
    @IBOutlet weak var favoritesTableView: UITableView!
    
    // Member Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        favoriteCards = dataModel.favoriteFlashcards()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    
    
    // Sets the number of sections per tableview cell
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    // Sets the number of tableview cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataModel.favoriteFlashcards().count
    }
    
    // Populates the tableview cells with all flashcard that are the users favorite
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
        let flashCard = favoriteCards[indexPath.row]
        cell.textLabel?.text = flashCard.getQuestion()
        cell.detailTextLabel?.text = flashCard.getAnswer()
        return cell
    }
    
    // Will reload the table view data everytime that the view appears
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        favoriteCards = dataModel.favoriteFlashcards()
        favoritesTableView.reloadData()
    }
}
