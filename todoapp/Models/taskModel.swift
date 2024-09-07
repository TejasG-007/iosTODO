//
//  taskModel.swift
//  todoapp
//
//  Created by Tejas on 03/09/24.
//

import Foundation


struct UserTaskModel:Identifiable,Hashable{
    let id = UUID()
    let taskName:String
    let isCompleted:Bool
    let creationDate:Date
}
