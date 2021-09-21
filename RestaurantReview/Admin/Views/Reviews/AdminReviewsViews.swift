//
//  AdminReviewsViews.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct AdminReviewsViews: View {
    
    @StateObject var viewModel: AdminReviewsViewModel
    @State private var error: String = ""
    @State private var alert: Bool = false
    @State private var moveToAddScreen = false
    
    var body: some View {
        VStack {
            NavigationLink(destination:AddReviewView(viewModel: AdminAddReviewViewModel()), isActive: $moveToAddScreen) {
                EmptyView()
            }
            if viewModel.comments.count > 0{
                List {
                    ForEach(viewModel.comments) { comment in
                        ZStack {
                            NavigationLink(destination: EditReviewsView(viewModel: AdminEditReviewViewModel(review: comment))) {
                                CommentsCellView(comment: comment)
                            }
                        }
                    }
                    .onDelete { (indexSet) in
                        let idsToDelete = indexSet.map { viewModel.comments[$0].id }
                        guard let commentid = idsToDelete.first else { return }
                        viewModel.deleteComment(commentid!)
                    }
                }.onReceive(viewModel.$error) { error in
                    guard let error = error else { return }
                    self.error = error
                    alert = true
                }
            }else{
                Text("No Reviews")
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.async {
                viewModel.listComments()
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Reviews")
        .alert(isPresented: $alert, title: "", message: error)
        .navigationBarItems(trailing: Button(action: {
            self.moveToAddScreen = true
        }, label: {
            Image(systemName: "plus")
        })
        )
    }
}

struct AdminReviewsViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdminReviewsViews(viewModel: AdminReviewsViewModel())
        }
    }
}
