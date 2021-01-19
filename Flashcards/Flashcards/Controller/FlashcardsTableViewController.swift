//
//  FlashcardsTableViewController.swift
//  Flashcards
//
//  Created by Aron Vischjager on 4/4/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class FlashcardsTableViewController: UITableViewController
{
    // Member Variables
    private var dataModel = FlashcardsModel.sharedInstance
    private var rowIndex: Int = 0
    @IBOutlet weak var flashcardsTableView: UITableView!
    
    // Member Functions
    // Defines the number of sections within each tableview cell
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // Stores the row index that the user clicked on
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        rowIndex = indexPath.row
        performSegue(withIdentifier: "EditCardSegue", sender: self)
    }
    
    // Defines the number of rows within the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataModel.numberOfFlashcards()
    }

    // Updates the content within each tableview cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        let flashCard = dataModel.flashcard(at: indexPath.row)
        cell.textLabel?.text = flashCard?.getQuestion()
        cell.detailTextLabel?.text = flashCard?.getAnswer()
        return cell
    }
    
    // Moves the right info from the current view controller to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        segue.destination.modalPresentationStyle = .fullScreen
        if let AddEditVC = (segue.destination as? UINavigationController)?.topViewController as? AddEditViewController
        {
            if segue.identifier == "AddCardSegue"
            {
                AddEditVC.navTitleText = "Please add a new card"
                AddEditVC.instructionText = "Enter"
            }
            else
            {
                AddEditVC.navTitleText = "Please edit an existing card"
                AddEditVC.instructionText = "Modify"
                AddEditVC.editSelectedIndex = rowIndex
            }
        }
    }
    
    // Removes flashcards from the data model and updates the tableview
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            dataModel.removeFlashcard(at: indexPath.row)
            flashcardsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

  
    // Moves flashcards inside the data model and updates the tableview
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
        dataModel.rearrangeFlashcards(from: fromIndexPath.row, to: to.row)
        flashcardsTableView.moveRow(at: fromIndexPath, to: to)
    }
    
    // Gets called when the view loads
    override func viewDidLoad()
    {
        super.viewDidLoad()
        flashcardsTableView.delegate = self
        flashcardsTableView.dataSource = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    // Will reload the table view data everytime that the view appears
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        flashcardsTableView.reloadData()
    }

}
