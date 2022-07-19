//
//  RegistrationViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import Foundation

struct RegistrationViewModel {
    func registrate(title: String, date: Date, body: String) {
        let newProject = ProjectContent(
            title: title,
            deadline: date,
            body: body
        )
        
        ProjectUseCase().create(projectContent: newProject)
    }
}
