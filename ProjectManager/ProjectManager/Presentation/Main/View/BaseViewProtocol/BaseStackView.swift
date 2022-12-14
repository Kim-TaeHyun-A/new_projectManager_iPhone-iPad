//
//  BaseStackView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

// MARK: - iPad

final class BaseStackView: UIStackView, BaseViewProtocol {
    private var viewModels: [ProjectListViewModelProtocol]
    lazy var projects: [ProjectListViewProtocol] = {
        return viewModels.map {
            ProjectStackView(with: $0)
        }
    }()
    
    init(viewModels: [ProjectListViewModelProtocol]) {
        self.viewModels = viewModels
        super.init(frame: .zero)
        
        setUpAttribute()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpAttribute() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        spacing = 10
        backgroundColor = .systemGray4
    }
    
    private func layout() {
        projects.forEach { addArrangedSubview($0) }
    }
}
