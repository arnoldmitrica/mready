//
//  RepositoryCellViewModel.swift
//  mready
//
//  Created by Arnold Mitricã on 10.05.2021.
//

import Foundation

struct RepositoryCellViewModel {
    let full_name:String
    init(with model: Item){
        self.full_name = model.fullName
    }
}

struct RepositoryDetailViewModel {
    let fullName:String
    let itemDescription:String
    let language:String?
    let avatarOwnerURL:String
    let ownerName:String
    let forkCount:Int?
    let stargazersCount:Int?
    let updatedAt:String?
    init(fullName:String, itemDescription: String, language: String?, avatarOwnerURL:String, ownerName: String, forkCount:Int?, stargazersCount:Int?, updatedAt:String?){
        self.fullName = fullName
        self.itemDescription = itemDescription
        self.language = language
        self.avatarOwnerURL = avatarOwnerURL
        self.ownerName = ownerName
        self.forkCount = forkCount
        self.stargazersCount = stargazersCount
        self.updatedAt = updatedAt
    }
    
}
