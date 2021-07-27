//
//  RestaurantListView.swift
//  RestaurantListView
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct RestaurantListView: View {
    
    @StateObject var viewModel: RestaurantViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            
            if viewModel.restaurants.count > 0 {
                List {
                    ForEach(viewModel.restaurants) { restaurant in
                        ZStack{
                            RestaurantCellView(restaurant: restaurant)
                            NavigationLink(destination: RestaurantDetailsView(viewModel: RestaurantDetailsViewModel(restaurant: restaurant, userModel: viewModel.userModel))){
                            }.frame(width: 0).opacity(0.0)
                        }
                    }
                }
            } else{
                Text("No restaurant")
            }
        }
        .onAppear {
            viewModel.fetchRestaurants()
        }
        .navigationTitle("Restaurants")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
                                Button(action: {
                                    UserDefaults.standard.removeObject(forKey: "token")
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "power")
                                }))
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantListView(viewModel: RestaurantViewModel(userModel: UserModel(id: 1, firstname: "", lastname: "", email: "", token: "", username: "", is_superuser: false, is_staff: false)))
        }
    }
}

struct RestaurantCellView: View {
    
    var restaurant: RestaurantModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            VStack (alignment: .leading, spacing: 8){
                Text(restaurant.name ?? "")
                    .bold()
                    .font(.system(size: 15))
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    Text(restaurant.address ?? "")
                        .font(.system(size: 11))
                }
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.red)
                    Text(restaurant.contact ?? "")
                        .font(.system(size: 11))
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                Text(String(format: "%.1f", restaurant.avg ?? 0.0))
                    .frame(width: 30, height: 20, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 1))
                    .font(.system(size: 11))
            }
        }
    }
}
