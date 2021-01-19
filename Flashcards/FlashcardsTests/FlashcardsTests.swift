//
//  FlashcardsTests.swift
//  FlashcardsTests
//
//  Created by Aron Vischjager on 2/27/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import XCTest
@testable import Flashcards
class VischjagerAronHW6Tests: XCTestCase
{
    // Member Variables
    private var dataModelInstance:FlashcardsModel?
    private var stringVar:String?
    
    // Member Functions
    override func setUp()
    {
        dataModelInstance = FlashcardsModel()
        resetEnv()
    }
    
    // Init testing environment
    func resetEnv()
    {
        let numCards = dataModelInstance?.numberOfFlashcards() ?? 0
        if (numCards > 0) {
            for i in (0...numCards-1).reversed()
            {
                dataModelInstance?.removeFlashcard(at: i)
            }
        }
        
        dataModelInstance?.insertQuestions()
    }
    
    // Checks whether adding an item to model1 will also add it to model2
    func testSharedModel()
    {
        let model1 = FlashcardsModel.sharedInstance
        let model2 = FlashcardsModel.sharedInstance
        model1.insert(question: "Day is valentines day", answer: "February 14, 2020", favorite: true)
        XCTAssertEqual(model1.favoriteFlashcards(), model2.favoriteFlashcards())
    }
    // Checks whether the numberOfFlashcards() method always displays the correct value
    func testNumCards()
    {
        XCTAssertEqual(dataModelInstance?.numberOfFlashcards(), 5)
        dataModelInstance?.insert(question: "Day is valentines day", answer: "February 14, 2020", favorite: true)
        XCTAssertEqual(dataModelInstance?.numberOfFlashcards(), 6)
        dataModelInstance?.removeFlashcard(at: 5)
        dataModelInstance?.removeFlashcard(at: 4)
        XCTAssertEqual(dataModelInstance?.numberOfFlashcards(), 4)
        dataModelInstance?.removeFlashcard(at: 3)
        dataModelInstance?.removeFlashcard(at: 2)
        dataModelInstance?.removeFlashcard(at: 1)
        dataModelInstance?.removeFlashcard(at: 0)
        XCTAssertEqual(dataModelInstance?.numberOfFlashcards(), 0)
    }
    // Checks whether the randomFlashcard method displays a different card everytime unless it contains 1 or 0 cards
    func testRandomCard()
    {
        var prevCard: Flashcard?
        var nextCard: Flashcard?
        prevCard = dataModelInstance?.currentFlashcard()
        nextCard = dataModelInstance?.randomFlashcard()
        XCTAssertNotEqual(prevCard?.getQuestion(), nextCard?.getQuestion())
        dataModelInstance?.removeFlashcard(at: 4)
        dataModelInstance?.removeFlashcard(at: 3)
        dataModelInstance?.removeFlashcard(at: 2)
        dataModelInstance?.removeFlashcard(at: 1)
        prevCard = dataModelInstance?.currentFlashcard()
        nextCard = dataModelInstance?.randomFlashcard()
        XCTAssertEqual(prevCard?.getQuestion(), nextCard?.getQuestion())
        dataModelInstance?.removeFlashcard(at: 0)
        prevCard = dataModelInstance?.currentFlashcard()
        nextCard = dataModelInstance?.randomFlashcard()
        XCTAssertEqual(prevCard?.getQuestion(), nextCard?.getQuestion())
    }
    // Tests whether the next flashcard function is moving to the card
    // at the next index until the last card is reached jumping back to the first card
    func testNextCard()
    {
        var currentCard: Flashcard?
        var cardAtIndex: Flashcard?
        // Index 0
        currentCard = dataModelInstance?.currentFlashcard()
        cardAtIndex = dataModelInstance?.flashcard(at: 0)
        XCTAssertEqual(currentCard?.getQuestion(), cardAtIndex?.getQuestion())
        // Index 1 - 4
        for i in 1...4
        {
            currentCard = dataModelInstance?.nextFlashcard()
            cardAtIndex = dataModelInstance?.flashcard(at: i)
            XCTAssertEqual(currentCard?.getQuestion(), cardAtIndex?.getQuestion())
        }
        // Index 0
        currentCard = dataModelInstance?.nextFlashcard()
        cardAtIndex = dataModelInstance?.flashcard(at: 0)
        XCTAssertEqual(currentCard?.getQuestion(), cardAtIndex?.getQuestion())
    }
    
    // Tests whether the next flashcard function is moving to the card
    // at the prev index until the first card is reached jumping back to the last card
    func testPrevCard()
    {
        var currentCard: Flashcard?
        var cardAtIndex: Flashcard?
        // Index 0
        currentCard = dataModelInstance?.currentFlashcard()
        cardAtIndex = dataModelInstance?.flashcard(at: 0)
        XCTAssertEqual(currentCard?.getQuestion(), cardAtIndex?.getQuestion())
        // Index 4 - 0
        for i in (0...4).reversed()
        {
            currentCard = dataModelInstance?.previousFlashcard()
            cardAtIndex = dataModelInstance?.flashcard(at: i)
            XCTAssertEqual(currentCard?.getQuestion(), cardAtIndex?.getQuestion())
        }
    }
    // Tests that the insert method adds items to the end of the array and will not change the currentIndex
    // Adding the first item will set the currentIndex to 0
    func testInsert()
    {
        // Tests any changes to currentIndex
        var currentCard1: Flashcard?
        var currentCard2: Flashcard?
        currentCard1 = dataModelInstance?.currentFlashcard()
        dataModelInstance?.insert(question: "Day is valentines day", answer: "February 14, 2020", favorite: true)
        currentCard2 = dataModelInstance?.currentFlashcard()
        XCTAssertEqual(currentCard1?.getQuestion(), currentCard2?.getQuestion())
        
        // Tests if item is added to the back
        var lastCard: Flashcard?
        lastCard = dataModelInstance?.flashcard(at: 5)
        XCTAssertEqual(lastCard?.getQuestion(), "Day is valentines day")
        
        // Tests whether calling currentFlashcard() on an empty list returns nil
        for i in (0...5).reversed()
        {
            dataModelInstance?.removeFlashcard(at: i)
        }
        currentCard1 = dataModelInstance?.currentFlashcard()
        XCTAssertNil(currentCard1)
        
        // Tests whether current index gets updated to 0 after first item gets added
        dataModelInstance?.insert(question: "Name a mammal that can’t jump.", answer: "Elephant, sloth, hippo, rhino", favorite: false)
        currentCard1 = dataModelInstance?.currentFlashcard()
        XCTAssertNotNil(currentCard1)
    }
    
    // Checks whether the current flashcard method return nil when the array is empty and a valid card otherwise
    func testCurrentCard()
    {
        var currentCard: Flashcard?
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertNotNil(currentCard)
        // Removing items from dataModel
        for i in (0...4).reversed()
        {
            dataModelInstance?.removeFlashcard(at: i)
        }
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertNil(currentCard)
    }
    
    // Checks whether the flashcard method returns the correct card when the index value is valid
    // returns nil otherwise
    func testFlashcard()
    {
        var currentCard: Flashcard?
        var cardAtIndex: Flashcard?
        currentCard = dataModelInstance?.currentFlashcard()
        cardAtIndex = dataModelInstance?.flashcard(at: 0)
        XCTAssertEqual(currentCard?.getQuestion(), cardAtIndex?.getQuestion())
        cardAtIndex = dataModelInstance?.flashcard(at: -1)
        XCTAssertNil(cardAtIndex)
        cardAtIndex = dataModelInstance?.flashcard(at: 100)
        XCTAssertNil(cardAtIndex)
    }
    
    // Checks the following items:
    // 1. Removing an item from an invalid index will not result in a out of bounds error
    // and it won't change the currentCard
    // 2. Removing an item at an index that is less than the currentIndex will shift the currentIndex
    // by 1 so that it remains the same position and that it won't cause an out of bounds error potentially
    // 3. Removing an item that is also the current index will not result
    // in a segfault when accessing the currentCard after(i.e. removing the first or last item)
    // 4. Removing the last item will set the currentIndex equal to nil
    func testRemoveCard()
    {
        // Test 1
        var currentCard: Flashcard?
        var nextCard: Flashcard?
        var lastCard: Flashcard?
        currentCard = dataModelInstance?.currentFlashcard()
        dataModelInstance?.removeFlashcard(at: -1)
        dataModelInstance?.removeFlashcard(at: 100)
        nextCard = dataModelInstance?.currentFlashcard()
        XCTAssertEqual(currentCard?.getQuestion(), nextCard?.getQuestion())
        // Test 2
        for _ in 1...4
        {
            currentCard = dataModelInstance?.nextFlashcard()
        }
        // lastCard == currentCard
        lastCard = dataModelInstance?.flashcard(at: 4)
        dataModelInstance?.removeFlashcard(at: 0)
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertEqual(currentCard?.getQuestion(), lastCard?.getQuestion())
        // Test 3
        // Remove current card at the end
        dataModelInstance?.removeFlashcard(at: 3)
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertNotNil(currentCard)
        // Removing current card at the beginning
        currentCard = dataModelInstance?.previousFlashcard()
        currentCard = dataModelInstance?.previousFlashcard()
        dataModelInstance?.removeFlashcard(at: 0)
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertNotNil(currentCard)
        // Removing last card
        dataModelInstance?.removeFlashcard(at: 0)
        dataModelInstance?.removeFlashcard(at: 0)
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertNil(currentCard)
    }
    // Tests that the bool value of the current card gets switched
    // from false to true or true to false
    func testToggleFavorite()
    {
        var currentCard: Flashcard?
        // False -> True
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertEqual(currentCard?.isFavorite, false)
        dataModelInstance?.toggleFavorite()
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertEqual(currentCard?.isFavorite, true)
        // True -> False
        dataModelInstance?.toggleFavorite()
        currentCard = dataModelInstance?.currentFlashcard()
        XCTAssertEqual(currentCard?.isFavorite, false)
    }
    // Tests the following functionality:
    // 1. An array without any favortite flashcards returns an empty list
    // 2. An array with 1 favortite flashcard, returns an array with that particular flashcard
    // 3. An array with 2 favorite flashcards, returns an array with both items inside
    func testFavoriteCards()
    {
        // Test 1
        var favorites: Array<Flashcard>?
        var favorite1: Flashcard?
        var favorite2: Flashcard?
        favorites = dataModelInstance?.favoriteFlashcards()
        XCTAssertEqual(favorites, [])
        // Test 2
        dataModelInstance?.toggleFavorite()
        favorite1 = dataModelInstance?.currentFlashcard()
        favorites = dataModelInstance?.favoriteFlashcards()
        XCTAssertEqual(favorites?[0].getQuestion(),favorite1?.getQuestion())
        // Test 3
        favorite2 = dataModelInstance?.nextFlashcard()
        dataModelInstance?.toggleFavorite()
        favorite2 = dataModelInstance?.currentFlashcard()
        if let favorites = dataModelInstance?.favoriteFlashcards()
        {
            XCTAssertEqual(favorites[0].getQuestion(),favorite1?.getQuestion())
            XCTAssertEqual(favorites[1].getQuestion(),favorite2?.getQuestion())
            XCTAssertEqual(favorites.count, 2)
        }
        else
        {
            XCTFail()
        }
    }
    
    // Tests the following
    // 1a. Inserting the card from index i to index j will shift the flashcards so that the relative othering among all other cards is remains the same
    // 1b. Current flashcard should always remain the same
    // 2. If an invalid insertion index is given, the flashcard should be added to the end
    func testRearrangeCard()
    {
        // Called to compared two cards
        func sameCards(_ card1: Flashcard, _ card2: Flashcard) -> Bool
        {
            guard let sameCard = dataModelInstance?.sameFlashCards(card1: card1, card2: card2) else
            {
                return false
            }
            if !sameCard
            {
                return false
            }
            return true
        }
        
        // Test 1a
        guard let prevFlashCards = dataModelInstance?.getFlashcards() else
        {
            XCTFail()
            return
        }
        
        // Checks that the position of the cards is correct
        dataModelInstance?.rearrangeFlashcards(from: 3, to: 1)
        for i in 0...4
        {
            guard let indexFlashcard = dataModelInstance?.flashcard(at: i) else
            {
                XCTFail()
                return
            }
            if i == 0
            {
                XCTAssertTrue(sameCards(prevFlashCards[0],indexFlashcard))
            }
            else if i == 1
            {
                XCTAssertTrue(sameCards(prevFlashCards[3],indexFlashcard))
            }
            else if i > 1 && i <= 3
            {
                XCTAssertTrue(sameCards(prevFlashCards[i-1],indexFlashcard))
            }
            else
            {
                XCTAssertTrue(sameCards(prevFlashCards[i],indexFlashcard))
            }
        }
        
        // Test 1b:
        print("test 1b")
        // 1. Current flashcard at: 0 -> current flashcard at: 0
        guard let prevCurrentFlashcard1 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        dataModelInstance?.rearrangeFlashcards(from: 3, to: 1)
        guard let newCurrentFlashcard1 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(sameCards(prevCurrentFlashcard1,newCurrentFlashcard1))
        
        // 2. Current flashcard at: 1 -> current flashcard at: 2
        // Moves current flashcard from index 0 -> 1
        dataModelInstance?.nextFlashcard()
        guard let prevCurrentFlashcard2 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        dataModelInstance?.rearrangeFlashcards(from: 3, to: 1)
        guard let newCurrentFlashcard2 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(sameCards(prevCurrentFlashcard2,newCurrentFlashcard2))
        
        // 3. Current flashcard at: 3 -> current flashcard at: 1
        // Moves current flashcard from index 1 -> 3
        dataModelInstance?.nextFlashcard()
        dataModelInstance?.nextFlashcard()
        guard let prevCurrentFlashcard3 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        dataModelInstance?.rearrangeFlashcards(from: 3, to: 1)
        guard let newCurrentFlashcard3 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        
        XCTAssertTrue(sameCards(prevCurrentFlashcard3,newCurrentFlashcard3))
        
        // 4. Current flashcard at: 4 -> current flashcard at: 4
        // Moves current flashcard from index 3 -> 4
        dataModelInstance?.nextFlashcard()
        guard let prevCurrentFlashcard4 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        dataModelInstance?.rearrangeFlashcards(from: 3, to: 1)
        guard let newCurrentFlashcard4 = dataModelInstance?.currentFlashcard() else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(sameCards(prevCurrentFlashcard4,newCurrentFlashcard4))
        
        // Test 2.
        // 1. Moves flashcard from index 3 -> -1 (Which goes to 4)
        guard let flashcardPrevIndex1 = dataModelInstance?.flashcard(at: 3) else
        {
            XCTFail()
            return
        }
        dataModelInstance?.rearrangeFlashcards(from: 3, to: -1)
        guard let flashcardNewIndex1 = dataModelInstance?.flashcard(at: 4) else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(sameCards(flashcardPrevIndex1,flashcardNewIndex1))
        // 1. Moves flashcard from index 3 -> 5 (Which goes to 4)
        guard let flashcardPrevIndex2 = dataModelInstance?.flashcard(at: 3) else
        {
            XCTFail()
            return
        }
        dataModelInstance?.rearrangeFlashcards(from: 3, to: 5)
        guard let flashcardNewIndex2 = dataModelInstance?.flashcard(at: 4) else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(sameCards(flashcardPrevIndex2,flashcardNewIndex2))
    }
    
    // Tests the following items:
    // 1. If the string literal is identical to one of the questions in the flashcards array, the function should return true
    // 2. If the string literal is identical to one of the questions in the flashcards array, expect for capitalization, the function should return true
    // 3. If the string literal is similar to one of the questions in the flashcards array, but contains punctuation marks and/or different amount of spacing the function should return true
    // 4. If the string contains at least one character that is different aside from spacing or punctuation marks, the function should return true
    func testCheckAskedQuestion()
    {
        // Test 1
        guard let questionAsked1 = dataModelInstance?.checkAskedQuestion(potentialQuestion: "What is the fastest land animal?") else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(questionAsked1)
        
        // Test 2
        guard let questionAsked2 = dataModelInstance?.checkAskedQuestion(potentialQuestion: "what is the fastest land animal?") else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(questionAsked2)
        
        // Test 3
        guard let questionAsked3 = dataModelInstance?.checkAskedQuestion(potentialQuestion: "\"    What    is the fastest land animal? \"") else
        {
            XCTFail()
            return
        }
        XCTAssertTrue(questionAsked3)
        
        // Test 4
        guard let questionAsked4 = dataModelInstance?.checkAskedQuestion(potentialQuestion: "Wha is the fastest land animal?") else
        {
            XCTFail()
            return
        }
        XCTAssertFalse(questionAsked4)
    }
    
    // Tests the following functionality
    // 1. Calling the edit flashcard function with an an invalid index as parameter should not alter any flashcard, and it should not cause a segfault either
    // 2. Calling the edit flashcard function with a valid index should replace the question, answer, isFavorite values of the question at the given index while while keeping all other items unchanged.
    func testEditFlashcard()
    {
        
        // Called to compared two cards
        func sameCards(_ card1: Flashcard, _ card2: Flashcard) -> Bool
        {
            guard let sameCard = dataModelInstance?.sameFlashCards(card1: card1, card2: card2) else
            {
                return false
            }
            if !sameCard
            {
                return false
            }
            return true
        }
        
        // Test 1
        guard let prevFlashCards1 = dataModelInstance?.getFlashcards() else
        {
            XCTFail()
            return
        }
        dataModelInstance?.editFlashcard(at: -1, question: "test1 ", answer: "test 2", favorite: true)
        guard let newFlashCards1 = dataModelInstance?.getFlashcards() else
        {
            XCTFail()
            return
        }
        for i in 0...4
        {
             XCTAssertTrue(sameCards(prevFlashCards1[i], newFlashCards1[i]))
        }
        
        // Test 2
        guard let prevFlashCards2 = dataModelInstance?.getFlashcards() else
        {
            XCTFail()
            return
        }
        dataModelInstance?.editFlashcard(at: 2, question: "test1", answer: "test 2", favorite: true)
        guard let newFlashCards2 = dataModelInstance?.getFlashcards() else
        {
            XCTFail()
            return
        }
        for i in 0...4
        {
            if i != 2
            {
                XCTAssertTrue(sameCards(prevFlashCards2[i], newFlashCards2[i]))
            }
            else
            {
                XCTAssertFalse(sameCards(prevFlashCards2[i], newFlashCards2[i]))
                XCTAssertEqual(newFlashCards2[i].getAnswer(), "test 2")
                XCTAssertEqual(newFlashCards2[i].getQuestion(), "test1")
                XCTAssertEqual(newFlashCards2[i].isFavorite, true)
            }
        }
    }
}
