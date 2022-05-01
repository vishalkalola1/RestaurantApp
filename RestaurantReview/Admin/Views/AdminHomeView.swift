//
//  AdminHomeView.swift
//  AdminHomeView
//
//  Created by Vishal on 7/25/21.
//

import SwiftUI

struct AdminHomeView: View {
    
    var userModel: UserModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var orientation: UIInterfaceOrientation = .portrait
    @State private var moveToReviews = false
    @State private var moveToRestaurant = false
    @State private var moveToUsers = false
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                if orientation.isLandscape {
                    HStack(alignment: .center, spacing: 3) {
                        UserBox(width:  (geo.size.width/3) - 3, height: geo.size.height, moveToUsers: $moveToUsers)
                            .cornerRadius(10)
                        RestaurantBox(width:  (geo.size.width/3) - 3, height: geo.size.height, moveToRestaurant: $moveToRestaurant)
                            .cornerRadius(10)
                        ReviewBox(width: (geo.size.width/3) - 3, height: geo.size.height, moveToReviews: $moveToReviews)
                            .cornerRadius(10)
                    }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .navigationTitle("Admin")
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(trailing:
                                                Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "power")
                        }
                    ))
                } else {
                    VStack(alignment: .center, spacing: 3) {
                        UserBox(width:  geo.size.width, height: geo.size.height/3, moveToUsers: $moveToUsers)
                            .cornerRadius(10)
                        RestaurantBox(width:  geo.size.width, height: geo.size.height/3, moveToRestaurant: $moveToRestaurant)
                            .cornerRadius(10)
                        ReviewBox(width:  geo.size.width, height: geo.size.height/3, moveToReviews: $moveToReviews)
                            .cornerRadius(10)
                    }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .navigationTitle("Admin")
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(trailing:
                                                Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "power")
                        }
                                                      ))
                        .onRotate { newOrientation in
                            orientation = newOrientation == .unknown ? .landscapeLeft : newOrientation
                        }
                }
                NonTappableNavigation(destination: AdminReviewsViews(viewModel: AdminReviewsViewModel()), isActive: $moveToReviews)
                NonTappableNavigation(destination: AdminRestaurantsView(viewModel: AdminRestaurantViewModel(userModel: userModel)), isActive: $moveToRestaurant)
                NonTappableNavigation(destination: AdminUsersView(viewModel: AdminUsersViewModel()), isActive: $moveToUsers)
            }
            .onRotate { newOrientation in
                orientation = newOrientation == .unknown ? .landscapeLeft : newOrientation
            }
            .onAppear {
                orientation = self.getOrientation()
            }
        }.padding(3)
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdminHomeView(userModel: UserModel(id: 1, firstname: "", lastname: "", email: "", token: "", username: "", is_superuser: true, is_staff: true))
                .previewInterfaceOrientation(.landscapeLeft)
        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.portrait)
    }
}

struct ReviewBox: View {
    
    var width: CGFloat
    var height: CGFloat
    
    @Binding var moveToReviews: Bool
    
    var body: some View {
        ZStack {
            Image("restaurant")
                .resizable()
                .frame(width:width, height: height, alignment: .center)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).opacity(0.5)
            
            Button {
                moveToReviews = true
            } label: {
                Text("Reviews")
                    .bold()
                    .font(.title)
                    .frame(width: width, height: height, alignment: .center)
            }.frame(width: width, height: height, alignment: .center)
            .foregroundColor(.white)
        }.frame(width: width, height: height, alignment: .center)
    }
}

struct RestaurantBox: View {
    
    var width: CGFloat
    var height: CGFloat
    @Binding var moveToRestaurant: Bool
    
    var body: some View {
        ZStack {
            Image("restaurant")
                .resizable()
                .frame(width:width, height: height, alignment: .center)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).opacity(0.5)
            Button {
                moveToRestaurant = true
            } label: {
                Text("Restaurants")
                    .bold()
                    .font(.title)
                    .frame(width: width, height: height, alignment: .center)
            }.frame(width: width, height: height, alignment: .center)
            .foregroundColor(.white)
        }.frame(width: width, height: height, alignment: .center)
    }
}

struct UserBox: View {
    
    var width: CGFloat
    var height: CGFloat
    @Binding var moveToUsers: Bool
    
    var body: some View {
        ZStack {
            Image("restaurant")
                .resizable()
                .frame(width:width, height: height, alignment: .center)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).opacity(0.5)
            
            Button {
                moveToUsers = true
            } label: {
                Text("Users")
                    .bold()
                    .font(.title)
                    .frame(width: width, height: height, alignment: .center)
            }.frame(width: width, height: height, alignment: .center)
            .foregroundColor(.white)
        }.frame(width: width, height: height, alignment: .center)
    }
}
