//
//  MainView.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import UIKit

final class MainView: UIView {
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let toDoTableView = ProjectTableView()
    private let doingTableView = ProjectTableView()
    private let doneTableView = ProjectTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableViews()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableViews() {
        baseStackView.addArrangedSubview(toDoTableView)
        baseStackView.addArrangedSubview(doingTableView)
        baseStackView.addArrangedSubview(doneTableView)
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}