//
//  ContentView.swift
//  RecipeFinder
//
//  Created by Seng Rith on 3/15/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var desserts = [DessertItem]()
    
    var body: some View {
        NavigationView {
                ScrollView{
                    DessertItem(strMeal: "Whatever this is is cool", strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", idMeal: "53049")
                }
                .navigationTitle("Dessert Recipes").font(.largeTitle)
                .navigationBarTitleDisplayMode(.automatic)
                .onAppear(perform: fetchDessertsData)
        }
    }
    
    func fetchDessertsData() {
        print("Fetching Data")
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
               URLSession.shared.dataTask(with: url) { data, _, error in
                   if let error = error {
                       print("Error fetching data: \(error.localizedDescription)")
                       return
                   }
                   guard let data = data else { return }
                   print(data)
               }.resume()
    }
}

struct DessertRecipeScreen: View {
    var id: String
 
    var body: some View {
        Text("Recipe of Dessert 1 \(id)").navigationTitle("Recipe Details")
        
    }
}

struct DessertItem: View {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
    
    var body: some View {
        NavigationLink(
            destination: DessertRecipeScreen(id: idMeal)) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 120)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    HStack {
                        AsyncImage(url: URL(string: "\(strMealThumb)"))
                        { image in
                            image.resizable()
                                .cornerRadius(CGFloat.init(floatLiteral: 12))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .padding()
                        
                        Spacer()
                        
                        Text("\(strMeal)")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.trailing, 10)
                    }
                  
                    
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
