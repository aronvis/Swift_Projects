//
//  FlashcardsModel.swift
//  Flashcards
//
//  Created by Aron Vischjager on 2/27/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import Foundation

class FlashcardsModel: NSObject, FlashcardsDataModel
{
    // Member Variables
    private var flashcards: Array<Flashcard>
    private var currentIndex: Int? = nil
    private var cardsFileLocation: URL!
    var questionDisplayed: Bool = true
    static let sharedInstance = FlashcardsModel()
    
    // Member Functions
    override init()
    {
        self.flashcards = [Flashcard]()
        self.currentIndex = 0
        super.init()
        self.initData()
    }
    
    // Checks if any flashcard data is stored inside flashcards.json
    // loads default flashcards otherwise
    private func initData()
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        cardsFileLocation = documentsDirectory.appendingPathComponent("flashcards.json")
        if FileManager.default.fileExists(atPath: cardsFileLocation.path)
        {
            load()
        }
        else
        {
            self.insertQuestions()
        }
    }
    
    
    
    // Read from peristent storage (documents folder)
    private func load()
    {
        do
        {
            let data = try Data(contentsOf: cardsFileLocation)
            let decoder = JSONDecoder()
            flashcards = try decoder.decode([Flashcard].self, from: data)
        }
        catch
        {
            print("err \(error)")
        }
    }
    
    // Save to persistent storage (documents folder)
    private func save()
    {
        do
        {
            let encoder = JSONEncoder()
            let data = try encoder.encode(flashcards)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: cardsFileLocation, atomically: true, encoding: .utf8)
        }
        catch
        {
            print("err \(error)")
        }
    }
    
    // Inserts 5 questions into the data model
    func insertQuestions()
    {
        self.insert(question: "Name a mammal that can’t jump.", answer: "Elephant, sloth, hippo, rhino", favorite: false)
        self.insert(question: "What is the fastest land animal?", answer: "The cheetah. They have set record speeds near 70 MPH.", favorite: false)
        self.insert(question: "What is the fastest aquatic animal?", answer: "The sailfish. It can reach speeds of up to 68 MPH.", favorite: false)
        self.insert(question: "What was the lifespan of a Tyrannosaurus Rex?", answer: "Between 20-30 years", favorite: false)
        self.insert(question: "What is the sweet food made by bees?", answer: "Honey", favorite: false)
    }
    
    func numberOfFlashcards() -> Int
    {
        return flashcards.count
    }
    
    func randomFlashcard() -> Flashcard?
    {
        guard let currIndex = currentIndex else
        {
            return nil
        }
        if numberOfFlashcards() == 0
        {
            currentIndex = nil
            return nil
        }
        var nextIndex = currIndex
        // Generates new random numbers until the random card
        // is different than the current card
        while nextIndex == currIndex && numberOfFlashcards() > 1
        {
            nextIndex = Int.random(in: 0..<flashcards.count)
        }
        currentIndex = nextIndex
        return flashcards[nextIndex]
    }
    
    func nextFlashcard() -> Flashcard?
    {
        guard let index = currentIndex else
        {
            return nil
        }
        let nextIndex:Int = (index + 1) % numberOfFlashcards()
        currentIndex = nextIndex
        return flashcards[nextIndex]
    }
    
    func previousFlashcard() -> Flashcard?
    {
        guard let index = currentIndex else
        {
            return nil
        }
        var prevIndex:Int = (index - 1)
        if prevIndex < 0
        {
            prevIndex = numberOfFlashcards() - 1
        }
        currentIndex = prevIndex
        return flashcards[prevIndex]
    }
    
    func insert(question: String, answer: String, favorite: Bool)
    {
        flashcards.append(Flashcard(question: question, answer: answer, isFavorite: favorite))
        if(numberOfFlashcards() == 1)
        {
            currentIndex = 0
            questionDisplayed = true
        }
        save()
    }
    
    func currentFlashcard() -> Flashcard?
    {
        if let index = currentIndex
        {
            return flashcards[index]
        }
        return nil
    }
    
    func flashcard(at index: Int) -> Flashcard?
    {
        if (0 ..< numberOfFlashcards()).contains(index)
        {
            return flashcards[index]
        }
        return nil
    }
    
    func removeFlashcard(at index: Int)
    {
        if (0 ..< numberOfFlashcards()).contains(index)
        {
            // Lowers the current index by 1
            guard let currIndex = currentIndex else
            {
                return
            }
            // Checks if the index is less than to the current index
            // or if the current index is the last card
            if index < currIndex || (currIndex == numberOfFlashcards() - 1)
            {
                // At least 1 item left after remove
                if (numberOfFlashcards() > 1)
                {
                    if currIndex > 0
                    {
                        currentIndex = currIndex - 1
                    }
                }
                // Empty array of flashcards
                else
                {
                    currentIndex = nil
                    questionDisplayed = false;
                }
            }
            flashcards.remove(at: index)
            save()
        }
    }
    
    func toggleFavorite()
    {
        if let index = currentIndex
        {
            if flashcards[index].isFavorite
            {
                flashcards[index].isFavorite = false
            }
            else
            {
                flashcards[index].isFavorite = true
            }
            save()
        }
    }
    
    func favoriteFlashcards() -> [Flashcard]
    {
        var output:Array<Flashcard> = [Flashcard]()
        for card in self.flashcards
        {
            if card.isFavorite
            {
                output.append(card)
            }
        }
        return output
    }
    
    // Returns true if the user has given a valid insertion index
    func validIndex(index: Int) -> Bool
    {
        if index >= 0 && index < numberOfFlashcards()
        {
            return true
        }
        return false
    }
       
    
    // Returns true if the user has given a valid insertion index
    func invalidInsertIndex(index: Int) -> Bool
    {
        if index < 0 || index > numberOfFlashcards()
        {
            return true
        }
        return false
    }
    
    // Inserts a flashcard at a given index and updates the currentCard if needed
    func insertAtIndex(card: Flashcard, index: Int, newCurrentCard: Bool = false)
    {
        // Inserts at the end if the user entered invalid index
        var insertIndex = index
        if invalidInsertIndex(index: insertIndex)
        {
            insertIndex = numberOfFlashcards()
        }
        flashcards.insert(card, at: insertIndex)
        // Sets the current flashcard to be the current card
        if newCurrentCard
        {
            currentIndex = insertIndex
            return
        }
        // Increments the current index of the other flashcard by 1 if
        // if the item is located after the current flashcard
        guard let currIndex = currentIndex else
        {
            return
        }
        if currIndex >= insertIndex
        {
            currentIndex = currIndex + 1
        }
        save()
    }
    
    // Returns true if a given flashcard is the current flashcard
    func iscurrentFlashcard(index: Int) -> Bool
    {
        if let currIndex = currentIndex
        {
            if currIndex == index
            {
                return true
            }
        }
        return false
    }
    
    // Moves the flashcard from one index to another
    func rearrangeFlashcards(from: Int, to: Int)
    {
        guard let flashCard = flashcard(at: from) else
        {
            return
        }
        if iscurrentFlashcard(index: from)
        {
            removeFlashcard(at: from)
            insertAtIndex(card: flashCard, index: to, newCurrentCard: true)
        }
        else
        {
            removeFlashcard(at: from)
            insertAtIndex(card: flashCard, index: to, newCurrentCard: false)
        }
        save()
    }
    
    // Returns true if two flashcards are the same
    func sameFlashCards(card1: Flashcard?, card2: Flashcard?) -> Bool
    {
        guard let flashcard1 = card1 else
        {
            return false
        }
        guard let flashcard2 = card2 else
        {
            return false
        }
        if flashcard1.getAnswer() != flashcard2.getAnswer()
            || flashcard1.getQuestion() != flashcard2.getQuestion()
            || flashcard1.isFavorite != flashcard2.isFavorite
        {
            return false
        }
        return true
    }
    
    // Returns true if the potential question is already in the array
    func checkAskedQuestion(potentialQuestion: String) -> Bool
    {
        let formattedPotentialQuestion = potentialQuestion.pureString.lowercased()
        for card in flashcards
        {
            if card.getQuestion().pureString.lowercased() == formattedPotentialQuestion
            {
                return true
            }
        }
        return false
    }
    
    // Replaces the question, answer and isFavorite value of a flashcard if it is located
    // at a valid index value
    func editFlashcard(at: Int, question: String, answer: String, favorite: Bool)
    {
        if validIndex(index: at)
        {
            let newFlashcard = Flashcard(question: question, answer: answer, isFavorite: favorite)
            if iscurrentFlashcard(index: at)
            {
                removeFlashcard(at: at)
                insertAtIndex(card: newFlashcard, index: at, newCurrentCard: true)
            }
            else
            {
                removeFlashcard(at: at)
                insertAtIndex(card: newFlashcard, index: at, newCurrentCard: false)
            }
            save()
        }
    }
    
    // Returns the array of flashcards
    func getFlashcards() -> [Flashcard]
    {
        return flashcards
    }
}
