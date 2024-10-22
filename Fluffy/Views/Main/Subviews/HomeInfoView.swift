//
//  HomeInfoView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

struct HomeInfoView: View {
    
    var cityName       : String = "City Name"
    var degree         : Int    = 10
    var weatherStatus  : String = "Sunny"
    var highestDegree  : Int    = 18
    var lowestDegree   : Int    = 9
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(cityName)
                .font(.largeTitle)
            Text("\(degree)°")
                .font(.system(size: 96).weight(.thin))
                .foregroundColor(.primary)
            Text(weatherStatus)
                .font(.title3.weight(.semibold))
                .foregroundColor(.secondary)
            HStack(spacing: 12) {
                Text("H \(highestDegree)°")
                Text("L \(lowestDegree)°")
            }
            .font(.title3.weight(.semibold))
        }
    }
}

#Preview {
    ZStack{
        HomeInfoView()
    }
}
