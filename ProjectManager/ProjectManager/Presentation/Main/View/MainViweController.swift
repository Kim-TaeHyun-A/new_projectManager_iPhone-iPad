//
//  MainViweController.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class MainViweController: UIViewController {
    private let mainView = MainView(frame: .zero)

    private let disposeBag = DisposeBag()
    private var viewModel = MainViewModel()
    
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
            target: nil,
            action: nil
        )
        didTapAddButton()
    }
    
    private func didTapAddButton() {
        guard let addButton = navigationItem.rightBarButtonItem else {
            return
        }
        
        addButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presentRegistrationView()
            }).disposed(by: disposeBag)
    }
    
    private func presentRegistrationView() {
        let next = UINavigationController(rootViewController: RegistrationViewController())
        
        next.modalPresentationStyle = .formSheet
        
        present(next, animated: true)
    }
    
    private func bind() {
        setUpTable()
        setUpTotalCount()
        setUpPopOverView()
    }
    
    private func setUpTable() {
        setUpSelection()
        setUpTableCellData()
        setUpdModelSelected()
    }
    
    private func setUpSelection() {
        mainView.toDoTable.tableView.rx
            .itemSelected
            .bind { [weak self] indexPath in
                self?.mainView.toDoTable.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.doingTable.tableView.rx
            .itemSelected
            .bind { [weak self] indexPath in
                self?.mainView.doingTable.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.doneTable.tableView.rx
            .itemSelected
            .bind { [weak self] indexPath in
                self?.mainView.doneTable.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUpTableCellData() {
        viewModel.todoProjects
            .drive(mainView.toDoTable.tableView.rx.items(
                cellIdentifier: "\(ProjectCell.self)",
                cellType: ProjectCell.self)
            ) { _, item, cell in
                cell.compose(content: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.doingProjects
            .drive(mainView.doingTable.tableView.rx.items(
                cellIdentifier: "\(ProjectCell.self)",
                cellType: ProjectCell.self)
            ) { _, item, cell in
                cell.compose(content: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.doneProjects
            .drive(mainView.doneTable.tableView.rx.items(
                cellIdentifier: "\(ProjectCell.self)",
                cellType: ProjectCell.self)
            ) { _, item, cell in
                cell.compose(content: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUpdModelSelected() {
        mainView.toDoTable.tableView.rx
            .modelSelected(ProjectContent.self)
            .asDriver()
            .drive { [weak self] element in
                self?.presentViewController(title: "TODO", content: element)
            }
            .disposed(by: disposeBag)
        
        mainView.doingTable.tableView.rx
            .modelSelected(ProjectContent.self)
            .asDriver()
            .drive { [weak self] element in
                self?.presentViewController(title: "DOING", content: element)
            }
            .disposed(by: disposeBag)
        
        mainView.doneTable.tableView.rx
            .modelSelected(ProjectContent.self)
            .asDriver()
            .drive { [weak self] element in
                self?.presentViewController(title: "DONE", content: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func presentViewController(title: String, content: ProjectContent) {
        let next = UINavigationController(
            rootViewController: DetailViewController(
                title: title,
                content: content,
                mainViewModel: viewModel
            )
        )
        
        next.modalPresentationStyle = .formSheet
        
        self.present(next, animated: true)
    }
    
    private func setUpTotalCount() {
        viewModel.todoProjects
            .map { "\($0.count)" }
            .drive { [weak self] count in
                self?.mainView.toDoTable.compose(projectCount: count)
            }
            .disposed(by: disposeBag)
        
        viewModel.doingProjects
            .map { "\($0.count)" }
            .drive { [weak self] count in
                self?.mainView.doingTable.compose(projectCount: count)
            }
            .disposed(by: disposeBag)
        
        viewModel.doneProjects
            .map { "\($0.count)" }
            .drive { [weak self] count in
                self?.mainView.doneTable.compose(projectCount: count)
            }
            .disposed(by: disposeBag)
    }
    
    func setUpPopOverView() {
        mainView.toDoTable.tableView.rx
            .longPressGesture().debug()
            .when(.began)
            .bind { event in
                let point = event.location(in: self.mainView.toDoTable.tableView)
                guard let indexPath = self.mainView.toDoTable.tableView.indexPathForRow(at: point),
                      let cell = self.mainView.toDoTable.tableView.cellForRow(at: indexPath) as? ProjectCell
                else {
                    return
                }
                
                let popOverViewController = PopOverViewController(cell: cell)
                self.present(popOverViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}

