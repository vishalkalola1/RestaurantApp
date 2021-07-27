//
//  UsersView.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct AdminUsersView: View {
    
    @StateObject var viewModel: AdminUsersViewModel
    @State private var error: String = ""
    @State private var alert: Bool = false
    @State private var moveToAddScreen = false
    
    var body: some View {
        VStack {
            if viewModel.users.count > 0 {
                List {
                    ForEach(viewModel.users) { user in
                        ZStack {
                            NavigationLink(destination: EditUsersView(viewModel: EditUserViewModel(user: user))) {
                                EmptyView()
                            }
                            AdminUserCellView(user: user)
                        }
                    }
                    .onDelete { (indexSet) in
                        let idsToDelete = indexSet.map { viewModel.users[$0].id }
                        guard let userid = idsToDelete.first else { return }
                        viewModel.deleteUser(userid!)
                    }
                }.onReceive(viewModel.$error) { error in
                    guard let error = error else { return }
                    self.error = error
                    alert = true
                }
                
            }else{
                Text("No Users")
            }
            NavigationLink(destination: AddUsersView(viewModel: AddUserViewModel()), isActive: $moveToAddScreen) {
                EmptyView()
            }
        }
        .onAppear(perform: {
            print("----------->>>>>>>>> Test")
            viewModel.listUsers()
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Users")
        .alert(isPresented: $alert, title: "", message: error)
        .navigationBarItems(trailing: Button(action: {
            self.moveToAddScreen = true
        }, label: {
            Image(systemName: "plus")
        })
        )
    }
}

struct AdminUsersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdminUsersView(viewModel: AdminUsersViewModel())
        }
    }
}

struct AdminUserCellView: View {
    
    var user: UserModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            VStack (alignment: .leading, spacing: 8){
                Text(user.fullname)
                    .bold()
                    .font(.system(size: 15))
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    Text(user.email ?? "")
                        .font(.system(size: 11))
                }
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.green)
                    Text(user.username ?? "")
                        .font(.system(size: 11))
                }
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.red)
                    Text((user.is_superuser ?? false) ? "Admin":"User")
                        .font(.system(size: 11))
                }
            }
            Spacer()
        }
    }
}

