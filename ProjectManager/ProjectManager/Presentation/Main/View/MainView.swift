//
//  MainView.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import UIKit
import RxCocoa

final class MainView: UIView {
    var toDoTable: ProjectListView?
    var doingTable: ProjectListView?
    var doneTable: ProjectListView?
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .systemGray4
        return stackView
    }()
    
    init(projectListViewModels: [ProjectListViewModelProtocol]) {
        super.init(frame: CGRect.zero)

        guard let todoViewModel = projectListViewModels.first(where: { $0.status == .todo }),
              let doingViewModel = projectListViewModels.first(where: { $0.status == .doing }),
              let doneViewModel = projectListViewModels.first(where: { $0.status == .done }) else {
            return
        }
        
        toDoTable = ProjectListView(with: todoViewModel)
        doingTable = ProjectListView(with: doingViewModel)
        doneTable = ProjectListView(with: doneViewModel)
        setUpBackgroundColor()
        setUpTableViews()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func setUpTableViews() {
        guard let toDoTable = toDoTable,
              let doingTable = doingTable,
              let doneTable = doneTable else {
            return
        }

        addSubview(baseStackView)
        
        baseStackView.addArrangedSubview(toDoTable)
        baseStackView.addArrangedSubview(doingTable)
        baseStackView.addArrangedSubview(doneTable)
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
