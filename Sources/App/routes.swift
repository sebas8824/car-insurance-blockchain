import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let blockchainController = BlockchainController()
    router.get("/api/blockchain", use: blockchainController.getBlockchain)
    router.post(Transaction.self, at: "/api/blockchain/mine", use: blockchainController.mine)
    router.post([BlockchainNode].self, at: "/api/blockchain/nodes/register", use: blockchainController.registerNodes)
    router.get("api/blockchain/nodes", use: blockchainController.getNodes)
    router.get("api/blockchain/resolve", use: blockchainController.resolve)
}
