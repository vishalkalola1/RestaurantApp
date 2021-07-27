//
//  AdminHomeView.swift
//  AdminHomeView
//
//  Created by Vishal on 7/25/21.
//

import SwiftUI

struct AdminHomeView: View {
    
    var userModel: UserModel?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                UserBox(width:  geo.size.width, height: geo.size.height/3)
                RestaurantBox(width:  geo.size.width, height: geo.size.height/3, userModel: userModel!)
                ReviewBox(width:  geo.size.width, height: geo.size.height/3)
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            .navigationTitle("Admin")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "power")
                                    }))
        }
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomeView(userModel: UserModel(id: 1, firstname: "", lastname: "", email: "", token: "", username: "", is_superuser: true, is_staff: true))
    }
}

struct ReviewBox: View {
    
    var width: CGFloat
    var height: CGFloat
    
    @State private var moveToReviews = false
    
    var body: some View {
        ZStack {
            Image("restaurant")
                .resizable()
                .frame(width:width, height: height, alignment: .center)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).opacity(0.5)
            NavigationLink(destination: AdminReviewsViews(viewModel: AdminReviewsViewModel()), isActive: $moveToReviews) {
                EmptyView()
            }
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
    var userModel: UserModel
    @State private var moveToRestaurant = false
    
    var body: some View {
        ZStack {
            Image("restaurant")
                .resizable()
                .frame(width:width, height: height, alignment: .center)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).opacity(0.5)
            NavigationLink(destination: AdminRestaurantsView(viewModel: AdminRestaurantViewModel(userModel: userModel)), isActive: $moveToRestaurant) {
                EmptyView()
            }
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
    @State private var moveToUsers = false
    
    var body: some View {
        ZStack {
            Image("restaurant")
                .resizable()
                .frame(width:width, height: height, alignment: .center)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).opacity(0.5)
            NavigationLink(destination: AdminUsersView(viewModel: AdminUsersViewModel()), isActive: $moveToUsers) {
                EmptyView()
            }
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
