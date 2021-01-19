//
//  StringFormatting.swift
//  Flashcards
//
//  Created by Aron Vischjager on 4/4/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import Foundation

extension String
{
    var pureString: String
    {
        let punctuationLess = self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
        let spaceLess = punctuationLess.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined(separator: "")
        return spaceLess
    }
    
}
