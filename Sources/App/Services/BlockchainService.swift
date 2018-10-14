//
//  BlockchainService.swift
//  App
//
//  Created by Sebastian on 10/14/18.
//

import Foundation

class BlockchainService {
    private (set) var blockchain: Blockchain!
    
    init() {
        self.blockchain = Blockchain(genesisBlock: Block())
    }
    
    func getBlockchain() -> Blockchain {
        return self.blockchain
    }
    
    func getNextBlock(transactions: [Transaction]) -> Block {
        let block = self.blockchain.getNextBlock(transactions: transactions)
        self.blockchain.addBlock(block)
        return block
    }
    
    func registerNodes(nodes: [BlockchainNode]) -> [BlockchainNode] {
        return self.blockchain.registerNodes(nodes: nodes)
    }
    
    func getNodes() -> [BlockchainNode] {
        return self.blockchain.nodes
    }
    
    /* Used to obtain the largest blockchain between the nodes */
    func resolve(completion: @escaping(Blockchain) -> ()) {
        let nodes = self.blockchain.nodes
        
        for node in nodes {
            let url = URL(string: "\(node.address)/api/blockchain")!
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    let blockchain = try! JSONDecoder().decode(Blockchain.self, from: data)
                    
                    if self.blockchain.blocks.count > blockchain.blocks.count {
                        completion(self.blockchain)
                    } else {
                        self.blockchain = blockchain
                        completion(blockchain)
                    }
                }
            }.resume()
        }
    }
}
