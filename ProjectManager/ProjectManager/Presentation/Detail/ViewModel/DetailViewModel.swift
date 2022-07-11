//
//  DetailViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import RxSwift
import RxRelay

class DetailViewModel {
    let content: ProjectContent
    
    init(content: ProjectContent) {
        self.content = content
    }
    
    func update(_ content: ProjectContent) {
        MockStorageManager.shared.update(projectContent: content)
    }
}