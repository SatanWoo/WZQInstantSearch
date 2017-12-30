//
//  WZQ.swift
//  WZQInstantSearch
//
//  Created by wu ziqi on 2017/12/27.
//  Copyright © 2017年 wu ziqi. All rights reserved.
//

import Foundation

public class WZQInstantSearch {
    
    public init(text:[String]) {
        texts = text
        index(text: text)
    }
    
    public func search(query:String) -> [String] {
        let processedQuery = WZQInstantSearch.preprocess(data: query)
        
        let terms = processedQuery.components(separatedBy: .whitespacesAndNewlines)
        let count = terms.count
        
        var result:[Int:Double] = [:]
        
        var maxScore:Double = 0.0
        
        for (idx, term) in terms.enumerated() {
            if let leafNode = trie.searchText(term: term) {
                WZQInstantSearch.updateScore(result: &result, leafNode: leafNode, count: count, maxScore: &maxScore)
            } else {
                if idx == count - 1 {
                    let leafs = trie.searchWithPrefix(prefix: term)
                    for (_, leaf) in leafs.enumerated() {
                        WZQInstantSearch.updateScore(result: &result, leafNode: leaf, count: count, maxScore: &maxScore)
                    }
                }
            }
        }
        
        let selectedIndex = result.filter { (v) -> Bool in
            return v.value >= maxScore
        }
        
        let str = selectedIndex.map { (v) -> String in
            return texts[v.key]
        }
        
        return str
    }
    
    private let trie:Trie = Trie()
    private let texts:[String]
    
    private static func makeLowerCase(s:String) -> String {
        return s.lowercased()
    }
    
    private static func removePuntucation(s:String) -> String {
        let punctuationRegex:String = "[!\"\',.:;?]"
        let regex = try! NSRegularExpression(pattern: punctuationRegex, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: s, options: [], range: NSMakeRange(0, s.count), withTemplate: "")
    }
    
    private static func removeStopWords(s:String) -> String {
        let stopWords = ["about", "after", "all", "also", "am", "an", "and", "another", "any", "are", "as", "at", "be", "because", "been", "before", "being", "between", "both", "but", "by", "came", "can", "come", "could", "did", "do", "each", "for", "from", "get", "got", "has", "had", "he", "have", "her", "here", "him", "himself", "his", "how", "if", "in", "into", "is", "it", "like", "make", "many", "me", "might", "more", "most", "much", "must", "my", "never", "now", "of", "on", "only", "or", "other", "our", "out", "over", "said", "same", "see", "should", "since", "some", "still", "such", "take", "than", "that", "the", "their", "them", "then", "there", "these", "they", "this", "those", "through", "to", "too", "under", "up", "very", "was", "way", "we", "well", "were", "what", "where", "which", "while", "who", "with", "would", "you", "your", "a", "i"]
        
        let components = s.components(separatedBy: .whitespacesAndNewlines)
        let ret = components.filter { (s:String) -> Bool in
            if stopWords.contains(s) {
                return false
            }
            return true
        }
        
        return ret.joined(separator:" ")
    }
    
    private static let templates:[(String) -> (String)] = [
        makeLowerCase,
        removePuntucation,
        removeStopWords
    ]
    
    private func index(text:[String]) -> Void {
        let processed = text.map { (s:String) -> String in
            return WZQInstantSearch.preprocess(data: s)
        }
        
        let termsArray = processed.map { (s:String) -> [String] in
            return s.components(separatedBy: .whitespacesAndNewlines)
        }
        
        let textCount = termsArray.count
        
        for (textIndex, terms) in termsArray.enumerated() {
            let termsCount = terms.count
            for (_, term) in terms.enumerated() {
                // 构建Trie树
                let leafData = WNLeafData(psignificance: Double(1.0) / Double(termsCount), pentries: [textIndex])
                trie.insertNode(str: term, data: leafData)
            }
        }
        
        trie.updateSiginificance(textCount: textCount)
    }
    
    private static func updateScore(result:inout [Int:Double], leafNode:WNLeafData, count:Int, maxScore:inout Double) -> Void {
        let updated = leafNode.significance * Double(1) / Double(count)
        
        for (_, index) in leafNode.entries.enumerated() {
            if let score = result[index] {
                result[index] = score + updated
            } else {
                result[index] = updated
            }
            
            if result[index]! > maxScore {
                maxScore = result[index]!
            }
        }
    }
    
    private static func preprocess(data:String) -> String {
        var result = data
        for (_, function) in templates.enumerated() {
            result = function(result)
        }
        return result
    }
}
