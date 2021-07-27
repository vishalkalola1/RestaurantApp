//
//  AddUsers.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct AddUsersView: View {
    
    @StateObject var viewModel: AddUserViewModel
    
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var isAdmin: Bool = false
    
    @State private var loading: Bool = false
    @State private var alert: Bool = false
    @State private var error: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .center, spacing: 25) {
                    TextFieldView(placeHolder: "First Name", imageName: "person", text: $firstname)
                    TextFieldView(placeHolder: "Last Name", imageName: "person", text: $lastname)
                    TextFieldView(placeHolder: "User Name", imageName: "person.fill", text: $username)
                    TextFieldView(placeHolder: "Email Id", imageName: "envelope", text: $email)
                    TextFieldView(placeHolder: "Password", imageName: "lock", text: $password, isSecure: true)
                    TextFieldView(placeHolder: "Confirm Password", imageName: "lock", text: $confirmpassword, isSecure: true)
                    HStack {
                        Text("Gender").font(.headline)
                        HStack{
                            RadioButtonField(
                                id: "Admin",
                                label: "Admin",
                                color:.blue,
                                bgColor: .blue,
                                isMarked: isAdmin ? true : false,
                                callback: {
                                    isAdmin = true
                                }
                            )
                            RadioButtonField(
                                id: "Normal",
                                label: "Normal",
                                color:.blue,
                                bgColor: .blue,
                                isMarked: isAdmin ? false : true,
                                callback: {
                                    isAdmin = false
                                }
                            )
                        }
                        Spacer()
                    }
                    
                }
            }.padding()
            VStack {
                if !loading {
                    Button {
                        if valid() {
                            loading = true
                            let credentials = ["first_name": firstname,
                                               "last_name": lastname,
                                               "email": email,
                                               "password": password,
                                               "is_staff": isAdmin,
                                               "is_superuser": isAdmin,
                                               "username":username] as [String : Any]
                            viewModel.add(credentials)
                        } else {
                            loading = false
                        }
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 150, height: 45, alignment: .center)
                            .background(Color.blue)
                            .font(.system(size: 13.0))
                            .cornerRadius(45, antialiased: false)
                    }
                    .alert(isPresented: $alert, title: "", message: error)
                    .background(Color.blue)
                    .cornerRadius(45, antialiased: true)
                } else {
                    Spinner()
                        .frame(width: 45, height: 45, alignment: .center)
                }
            }.onReceive(viewModel.$user) { user in
                DispatchQueue.main.async {
                    if loading == true {
                        loading = false
                        error = "User Added Succcessfully"
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }.onReceive(viewModel.$error) { error in
                guard let error = error else { return }
                DispatchQueue.main.async {
                    self.error = error
                    alert = true
                    loading = false
                }
            }
            Spacer()
        }.navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add")
    }
    
    func valid() -> Bool {
        if firstname == "" {
            self.error = "Please enter first name"
            return false
        } else if lastname == "" {
            self.error = "Please enter last name"
            return false
        } else if email == "" {
            self.error = "Please enter email"
            return false
        } else if password == "" {
            self.error = "Please enter password"
            return false
        } else if confirmpassword == "" {
            self.error = "Please enter confirm password"
            return false
        } else if password != confirmpassword {
            self.error = "Password and confirm password does not match"
            return false
        } else {
            return true
        }
    }
}

struct AddUsers_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddUsersView(viewModel: AddUserViewModel())
        }
    }
}
