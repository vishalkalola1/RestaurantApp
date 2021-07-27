//
//  SignUpView.swift
//  SignUpView
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel = SignUpViewModel()
    
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var loader: Bool = false
    @State private var alert: Bool = false
    @State private var error: String = ""
    @State private var moveToSuccess: Bool = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center, spacing: 20) {
                Spacer()
                VStack {
                    VStack {
                        Text("Let's Get Started!").font(.title).bold()
                        Text("Create an account to get all features")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                VStack {
                    VStack(alignment: .center, spacing: 15) {
                        TextFieldView(placeHolder: "First Name", imageName: "person", text: $firstname)
                        TextFieldView(placeHolder: "Last Name", imageName: "person", text: $lastname)
                        TextFieldView(placeHolder: "User Name", imageName: "person.fill", text: $username)
                        TextFieldView(placeHolder: "Email Id", imageName: "envelope", text: $email)
                        TextFieldView(placeHolder: "Password", imageName: "lock", text: $password, isSecure: true)
                        TextFieldView(placeHolder: "Confirm Password", imageName: "lock", text: $confirmpassword, isSecure: true)
                    }
                }.padding()
                
                VStack {
                    if !loader {
                        NavigationLink(destination: RestaurantListView(viewModel: RestaurantViewModel(userModel: (viewModel.tokenModel?.user)!)), isActive: $moveToSuccess) {
                            EmptyView()
                        }
                        Button {
                            let isValid = self.valid()
                            if isValid {
                                loader = true
                                let credentials = ["first_name": firstname,
                                                   "last_name": lastname,
                                                   "email": email,
                                                   "password": password,
                                                   "is_staff": false,
                                                   "is_superuser": false,
                                                   "username":username] as [String : Any]
                                self.viewModel.register(credentials)
                            } else {
                                alert = true
                            }
                        } label: {
                            Text("SIGN UP")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 150, height: 45, alignment: .center)
                                .background(Color.blue)
                                .font(.system(size: 15.0))
                                .cornerRadius(45, antialiased: false)
                        }
                        .alert(isPresented: $alert, title: "", message: error)
                        .background(Color.blue)
                        .cornerRadius(45, antialiased: true)
                    } else {
                        Spinner()
                            .frame(width: 45, height: 45, alignment: .center)
                    }
                }.onReceive(viewModel.$tokenModel) { user in
                    DispatchQueue.main.async {
                        guard let user = user else { return }
                        loader = false
                        if user.key == nil {
                            error = "Invalid credentials"
                            alert = true
                        } else {
                            self.moveToSuccess = true
                        }
                    }
                }.onReceive(viewModel.$error) { error in
                    guard let error = error else { return }
                    DispatchQueue.main.async {
                        self.error = error
                        alert = true
                        loader = false
                    }
                }
                Spacer()
                Spacer().frame(height: 30, alignment: .center)
            }
            .frame(minWidth:0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .center)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Register")
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
