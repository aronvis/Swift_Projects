//
//  ViewController.swift
//  RandomQuoteGenerator
//
//  Created by Aron Vischjager on 3/13/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit
class QuotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // --- Table View Setup -----
    // Member Variables
    @IBOutlet weak var quotesTableView: UITableView!
    
    // Member Functions
    // Defines the number of rows inside the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return QuoteService.shared.numberOfQuotes()
    }
    
    // Updates the content inside the table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // DequeueReusableCell: Gets a cell that has been previously created and isn’t currently used
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        // Row i, section 0
        let quote = QuoteService.shared.get(at: indexPath.row)
        cell.textLabel?.text = quote?.message
        cell.detailTextLabel?.text = quote?.author
        return cell
    }
     
    // --- Table View Edit Tools -----
    @IBAction func editButtonDidTapped(_ sender: UIBarButtonItem)
    {
        quotesTableView.isEditing = !quotesTableView.isEditing
    }
    
    // Allows user to remove cell if the user clicks on the edit
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            QuoteService.shared.remove(at: indexPath.row)
            quotesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Updates table view after returning from segue
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        quotesTableView.reloadData()
        
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
    }
}


