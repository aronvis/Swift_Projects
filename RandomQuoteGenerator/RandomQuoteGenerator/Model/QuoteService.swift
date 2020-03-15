//
//  QuoteService.swift
//  RandomQuoteGenerator
//
//  Created by Aron Vischjager on 3/13/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import Foundation

class QuoteService
{
    private var quotes = [Quote]()
    private init()
    {
        quotes =
        [
            Quote(message: "You missed 100% of the shots you don't take", author: "Linsday"),
            Quote(message: "What doesn't kill makes you stronger", author: "Ehsan"),
            Quote(message: "If you aim high, you can only go down from here", author: "Aron")
        ]
    }
    static let shared = QuoteService()
    func add(quote: Quote)
    {
        quotes.append(quote)
    }
    func remove(at index: Int)
    {
        quotes.remove(at: index)
    }
    func getRandomQuote() -> Quote?
    {
        return quotes.randomElement()
    }
    func numberOfQuotes() -> Int
    {
        return quotes.count
    }
    func get(at index: Int) -> Quote?
    {
        if index <= numberOfQuotes() - 1
        {
            return quotes[index]
        }
        return nil
    }
}
