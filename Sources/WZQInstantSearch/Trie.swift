//
//  Trie.swift
//  WZQInstantSearch
//
//  Created by wu ziqi on 2017/12/27.
//  Copyright © 2017年 wu ziqi. All rights reserved.
//

import Foundation

fileprivate let WZQAlphabet:Int = 26

fileprivate func offsetToAlphae (offset:Int) -> Character {
    let s:String = "abcdefghijklmnopqrstuvwxyz"
    return s[offset]
}

fileprivate func alphabetToOffset (c:Character) -> Int {
    let s:String = "abcdefghijklmnopqrstuvwxyz"
    assert(s.contains(c))
    
    if let index = s.index(of: c) {
        return s.distance(from: s.startIndex, to: index)
    } else {
        return NSNotFound
    }
}

class WNLeafData {
    var significance:Double = 0.0
    var entries:[Int] = []
    
    init(psignificance:Double, pentries:[Int]) {
        significance = psignificance
        entries = pentries
    }
}

class WNNode {
    var childs:[Int:WNNode] = [:];
    var leafData:WNLeafData?
}

class Trie {
    fileprivate var root:WNNode
    
    private var leafNodes:[WNNode] = []
    
    init() {
        root = WNNode()
    }
    
    func insertNode(str:String, data:WNLeafData?) -> Void {
        guard !str.isEmpty else { return }
        
        var currentNode = root
        var currentIndex = 0
        
        while currentIndex < str.characters.count {
            let c = str[currentIndex]
            let offset = alphabetToOffset(c: c)
            
            if let child = currentNode.childs[offset] {
                currentNode = child
            } else {
                currentNode.childs[offset] = WNNode()
                currentNode = currentNode.childs[offset]!
            }
            
            currentIndex += 1
            
            if currentIndex == str.characters.count {
                
                guard let newLeafData = data else {
                    return
                }
                
                if currentNode.leafData == nil {
                    currentNode.leafData = WNLeafData(psignificance: 0.0, pentries: [])
                    // 快速索引叶子节点
                    leafNodes.append(currentNode)
                }
                
                if let currentLeafData = currentNode.leafData {
                    currentLeafData.significance += newLeafData.significance
                    currentLeafData.entries.append(contentsOf: newLeafData.entries)
                }
            }
        }
    }
    
    func searchText(term:String) -> WNLeafData? {
        if let currentNode = searchNode(term: term) {
            return currentNode.leafData
        } else {
            return nil
        }
    }
    
    func searchWithPrefix(prefix:String) -> [WNLeafData] {
        guard prefix.count > 0 else { return [] }
        
        if let node = searchNode(term: prefix) {
            var stacks = [node]
            
            var result:[WNLeafData] = []
            
            while stacks.count > 0 {
                let top = stacks.first!
                for i in 0..<WZQAlphabet {
                    if let child = top.childs[i] {
                        stacks.append(child)
                    }
                }
                
                if let leaf = top.leafData {
                    result.append(leaf)
                }
                
                stacks.remove(at: 0)
            }
            
            return result
            
        } else {
            return []
        }
    }

    func updateSiginificance(textCount:Int) -> Void {
        for (_, node) in leafNodes.enumerated() {
            if let significance = node.leafData?.significance {
                node.leafData?.significance = 1.5 - significance / Double(textCount)
            }
        }
    }
    
    private func searchNode(term:String) -> WNNode? {
        guard term.count > 0 else {return nil}
        
        let count = term.count
        var index = 0
        
        var currentNode = root
        
        while index < count {
            let c = term[index]
            let offset = alphabetToOffset(c: c)
            guard let child = currentNode.childs[offset] else {
                return nil
            }
            
            currentNode = child
            index += 1
        }
        
        return currentNode
    }
}
