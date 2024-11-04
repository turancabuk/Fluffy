//
//  NavigationBarView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//

import SwiftUI

struct NavigationBarView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 23).weight(.medium))
                        Text("Weather")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                    .frame(height: 44)
                }
                Spacer()
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44, alignment: .trailing)
            }
            .frame(height: 52)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search a city or airport", text: $searchText)
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 7)
            .frame(height: 36, alignment: .leading)
            .background(Color.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 10))
            .innerShadow(shape: RoundedRectangle(cornerRadius: 10), color: .black, lineWidth: 1, offsetX: 0, offsetY: 2, blur: 2)
        }
        .frame(height: 106, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.top, 49)
        .makeBlurView(radius: 20, opaque: true)
        .background(Color.navBarBackground)
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationBarView(searchText: .constant(""))
}
