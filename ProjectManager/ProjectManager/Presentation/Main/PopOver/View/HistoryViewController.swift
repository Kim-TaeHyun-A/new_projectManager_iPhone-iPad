//
//  HistoryViewController.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/25.
//

import UIKit

final class HistoryViewController: UIViewController {
    private let historyView = HistoryView()
    
    override func loadView() {
        view = historyView
    }
}