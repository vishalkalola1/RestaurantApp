//
//  AdminRestaurantView.swift
//  AdminRestaurantView
//
//  Created by Vishal on 7/25/21.
//

import SwiftUI

struct AdminRestaurantsView: View {
    
    @StateObject var viewModel: AdminRestaurantViewModel
    @State private var error: String = ""
    @State private var alert: Bool = false
    @State private var moveToAddScreen = false
    var body: some View {
        VStack {
            if viewModel.restaurants.count > 0 {
                List {
                    ForEach(viewModel.restaurants) { restaurant in
                        ZStack {
                            NavigationLink(destination: EditRestaurantView(viewModel: EditRestaurantViewModel(restaurant: restaurant))) {
                                EmptyView()
                            }
                            AdminRestaurantCellView(restaurant: restaurant)
                        }
                    }.onDelete { (indexSet) in
                        let idsToDelete = indexSet.map { viewModel.restaurants[$0].id }
                        guard let restaurantid = idsToDelete.first else { return }
                        viewModel.deleteRestaurant(restaurantid!)
                    }
                }.onReceive(viewModel.$error) { error in
                    guard let error = error else { return }
                    self.error = error
                    alert = true
                }
            }else{
                Text("No restaurants")
            }
            NavigationLink(destination: AddRestaurantView(viewModel: AddRestaurantViewModel()), isActive: $moveToAddScreen) {
                EmptyView()
            }
        }
        .onAppear(perform: {
            viewModel.fetchRestaurants()
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Restaurants")
        .alert(isPresented: $alert, title: "", message: error)
        .navigationBarItems(trailing: Button(action: {
            self.moveToAddScreen = true
        }, label: {
            Image(systemName: "plus")
        })
        )
    }
}

struct AdminRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdminRestaurantsView(viewModel: AdminRestaurantViewModel(userModel: UserModel(id: 1, firstname: "", lastname: "", email: "", token: "", username: "", is_superuser: false, is_staff: false)))
        }
    }
}

struct AdminRestaurantCellView: View {
    
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
        }
    }
}
