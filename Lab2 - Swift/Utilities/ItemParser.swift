//
//  ItemParser.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-18.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation

struct XMLItem {
    var title: String
}

class ItemParser: NSObject, XMLParserDelegate {
    
    private var parserCompletionHandler: ((XMLItem) -> Void)?
    
    private var currentItem: XMLItem?
    private var currentElement = ""
    
    private var currentTitle:String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseItem(url: String, completionHandler: ((XMLItem) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        if url == "" {
            return
        } else {
            let request = URLRequest(url: URL(string: url)!)
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    return
                }
                
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            
            task.resume()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "Artikel" {
            currentTitle = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "Artikelbenamning" {
            currentTitle += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Artikel" {
            currentItem = XMLItem(title: currentTitle)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(currentItem!)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}

