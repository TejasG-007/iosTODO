//
//  homeScreenView.swift
//  todoapp
//
//  Created by Tejas on 24/08/24.
//

import SwiftUI


struct HomeView:View{
    @EnvironmentObject var userData:LoginOrRegisterViewModel
    
    let task:[UserTaskModel] = [
        UserTaskModel(taskName:"Task - 1", isCompleted: false, creationDate: Date.now),
        UserTaskModel(taskName:"Task - 2", isCompleted: true, creationDate: Date.now),
        UserTaskModel(taskName:"Task - 3", isCompleted: false, creationDate: Date.now),
        UserTaskModel(taskName:"Task - 4", isCompleted: true, creationDate: Date.now),
        UserTaskModel(taskName:"Task - 5", isCompleted: true, creationDate: Date.now),
        ]
    
    var body: some View{
        
        NavigationView{
            VStack{
                Spacer()
                VStack(alignment:.leading){
                    Spacer()
                    HStack{
                        Image(systemName: "circle.inset.filled").padding([.leading],10)
                        Text("Completed Task").font(.system(size: 20)).bold()
                    }
                    Spacer()
                    
                    List(task){
                        data in
                        Text(data.taskName)
                    }
                    
                }.frame(maxWidth: .infinity,alignment: .topLeading).background(.white)
                
                VStack(alignment:.leading){
                    Spacer()
                    HStack{
                        Image(systemName: "sheqelsign.circle").padding([.leading],10)
                        Text("Pending Task").font(.system(size: 20)).bold()
                    }
                    Spacer()
                    
                    List(task){
                        data in
                        Text(data.taskName)
                    }
                    
                }.frame(maxWidth: .infinity,alignment: .topLeading).background(.white)
                Spacer()
                
            }.navigationTitle("TaskMaster").toolbar(content: {
                ToolbarItem(placement:.cancellationAction){
                    HStack{
                        Circle().foregroundColor(.green)
                        Text("\(userData.currentUser?.displayName ?? "Hey!..")")
                    }
                }
                ToolbarItem(placement:.confirmationAction){
                    Button{
                        Task{
                            do{
                                try userData.logoutUser()
                            }catch{
                                print("Log out issue")
                            }
                        }
                        
                    }label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(.red)
                        
                    }

                }
        
            })
        }
        
    }
}

#Preview {
HomeView()
}
