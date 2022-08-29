//
//  NetworkCondition.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/21.
//

import Reachability

protocol NetworkConditionDelegate: AnyObject {
    func applyNetworkEnable()
    func applyNetworkUnable()
}

final class NetworkCondition {
    static let sharedInstance: NetworkCondition = {
        return NetworkCondition()
    }()
    private let reachability: Reachability?
    weak var delegate: NetworkConditionDelegate?
    
    private init() {
        self.reachability = try? Reachability()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        try? reachability?.startNotifier()
    }
}

extension NetworkCondition {
    @objc func networkStatusChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            return
        }
        
        switch reachability.connection {
        case .wifi, .cellular:
            delegate?.applyNetworkEnable()
        default:
            delegate?.applyNetworkUnable()
        }
    }
}
