//
//  DataModel.swift
//  Flashcards
//
//  Created by Aron Vischjager on 2/27/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import Foundation

//used for the data model
protocol FlashcardsDataModel {
    // Returns number of flashcards in model
    func numberOfFlashcards() -> Int
    
    // Returns a flashcard – sets currentIndex appropriately
    func randomFlashcard() -> Flashcard?
    func nextFlashcard() -> Flashcard?
    func previousFlashcard() -> Flashcard?
    
    // Inserts a flashcard to the end – sets currentIndex appropriately in certain situations
    func insert(question: String, answer: String, favorite: Bool)
    
    // Returns the current flashcard at currentIndex
    func currentFlashcard() -> Flashcard?
    
    //Returns a card at a given index
    func flashcard(at index: Int) -> Flashcard?
    
    // Removes a flashcard – sets currentIndex appropriately when removing from certain positionss
    func removeFlashcard(at index: Int)
    
    // Favorite/unfavorite the current flashcard
    func toggleFavorite()
    
    // Returns the favorite flashcards from your flashcards
    func favoriteFlashcards() -> [Flashcard]
    
    //added functions /////////
    //used to rearrange your flashcards
    func rearrangeFlashcards(from: Int, to: Int)
    //checks to see if the question has been asked already
    func checkAskedQuestion(potentialQuestion: String) -> Bool
    //allows you to
    func editFlashcard(at: Int, question: String, answer: String, favorite: Bool)
}


