//
//  MainViweController.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViweController: UIViewController {
    private let mainView = MainView(frame: .zero)

    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationItem()
        
        bind()
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "Project Manager"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(presentDetailView)
        )
    }
    
    @objc func presentDetailView() {
        let next = UINavigationController(rootViewController: RegistrationViewController())
        
        next.modalPresentationStyle = .formSheet
        
        present(next, animated: true)
    }
    
    private func bind() {
        guard let addButton = navigationItem.rightBarButtonItem else {
            return
        }
        
        let input = MainViewModel
            .Input(
                cellTapEvent: mainView.toDoTableView.rx.itemSelected.asObservable()
            )
        
        addButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presentDetailView()
            }).disposed(by: disposeBag)
        
        viewModel.toDoTableProjects
            .bind(to: mainView.toDoTableView.rx.items(
                cellIdentifier: "\(ProjectCell.self)",
                cellType: ProjectCell.self)
            ) { _, item, cell in
                cell.onData.onNext( item )
            }
            .disposed(by: disposeBag)
        
        viewModel.totalCount
            .bind(to: mainView.toDoTableView.countLabel.rx.text)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
    }
}
