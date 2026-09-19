//
//  SearchView.swift
//  SwiftUISearchBar
//
//  Created by Kinney Kare on 5/19/21.
//  Youtube
//  https://youtu.be/7kxjzEBjeNI

import SwiftUI

struct mySearchView: View {

    @EnvironmentObject var vm: MyShowsModel
    private enum Field: Int, Hashable {
        case searchText
    }
    @FocusState private var focusedField: Field?
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("SearchBar"))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search ...", text: $vm.searchText) { startedSearching in
                    if startedSearching {
                        withAnimation {
                            vm.searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        
                        vm.searching = false
                    }
                }.foregroundColor(.black)
                    .fontWeight(.bold)
                    .focused($focusedField, equals: .searchText)
                    .onAppear() {
                        focusedField = .searchText
                    }
                Button(action:  {
                    vm.searchText = ""
                    focusedField = .searchText
                }) {
                    Image(systemName: "x.circle")
                        .foregroundColor(.black)
                }
            }
            .foregroundColor(.gray)
            .padding()
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        mySearchView()
            .environmentObject(MyShowsModel())
    }
}
