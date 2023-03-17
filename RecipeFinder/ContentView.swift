/**
 *  Desert Recipe Screen for displaying desert recipes. All recipes are fetched the recipes
 *  from https://themealdb.com/api/json/v1/1/filter.php?c=Dessert
 */

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State var desserts = [DessertItem]()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Recipe List").font(.title).fontWeight(.bold)
                    ScrollView{
                        LazyVStack{
                            ForEach(desserts) { dessert in
                                DessertItem(strMeal: dessert.strMeal, strMealThumb: dessert.strMealThumb, idMeal: dessert.idMeal)
                                }
                        }
                    }
                    .navigationBarTitleDisplayMode(.automatic)
                    .onAppear{
                        fetchDessertsData()
                    }
                    .frame( alignment: .topLeading)
            }
        }
        
    }
    
    func fetchDessertsData() {
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            do {
                    let decodedData = try JSONDecoder().decode(DessertsListData.self, from: data)
                    DispatchQueue.main.async {
                        self.desserts = decodedData.meals
                }
            }
            catch {
                print("Error decoding data: \(error)")
            }
            
        }.resume()
    }
    
}

/**
 * Dessert Recipe Screen component. Given an id, it displays the recipe
 * information from endpoint:
 * https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID
 *
 */
struct DessertRecipeScreen: View {
    var id: String
    @State var info: RecipeInfo?
    @State private var loading = true
    @State private var ingredients = [String : String]()
    
    var body: some View {
        ScrollView{
            if(loading){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }else{
                if info == nil{
                    Text("Recipe is unavailable. :(")
                }else{
                    if let name = info?.strMeal {
                        Text("\(name)").font(.largeTitle).fontWeight(.semibold)
                        
                    }
                    
                    Spacer().frame(height: 50)
                    Text("Ingredients").frame(maxWidth: .infinity , alignment: .leading)
                        .padding(.leading, 15).fontWeight(.bold)
                    
                    VStack{
                        ForEach(ingredients.sorted(by: <), id: \.key) { key, value in
                            if(key != ""){
                                Text("- \(key): \(value)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 30)
                            }
                        }
                    }.padding(.top, 10)
                
                    
                    Spacer().frame(height: 30)
                    
                    Text("Instructions").fontWeight(.bold)
                    
                    if let instructions = info?.strInstructions {
                        ScrollView{
                            Text("\(instructions)")
                                .padding(.horizontal, 30)
                        }
                    }
                    
                }
            }
            
        }
        .frame( maxWidth: .infinity,
                maxHeight: .infinity)
        .onAppear{
                fetchRecipeData()
            }.onChange(of: info) { newValue in
                if(newValue != nil){
                    // Maps the ingredient name to its measurement
                    ingredients[newValue?.strIngredient1 ?? ""] = newValue?.strMeasure1
                    ingredients[newValue?.strIngredient2 ?? ""] = newValue?.strMeasure2
                    ingredients[newValue?.strIngredient3 ?? ""] = newValue?.strMeasure3
                    ingredients[newValue?.strIngredient4 ?? ""] = newValue?.strMeasure4
                    ingredients[newValue?.strIngredient5 ?? ""] = newValue?.strMeasure5
                    ingredients[newValue?.strIngredient6 ?? ""] = newValue?.strMeasure6
                    ingredients[newValue?.strIngredient7 ?? ""] = newValue?.strMeasure7
                    ingredients[newValue?.strIngredient8 ?? ""] = newValue?.strMeasure8
                    ingredients[newValue?.strIngredient9 ?? ""] = newValue?.strMeasure9
                    ingredients[newValue?.strIngredient10 ?? ""] = newValue?.strMeasure10
                    ingredients[newValue?.strIngredient11 ?? ""] = newValue?.strMeasure11
                    ingredients[newValue?.strIngredient12 ?? ""] = newValue?.strMeasure12
                    ingredients[newValue?.strIngredient13 ?? ""] = newValue?.strMeasure13
                    ingredients[newValue?.strIngredient14 ?? ""] = newValue?.strMeasure14
                    ingredients[newValue?.strIngredient15 ?? ""] = newValue?.strMeasure15
                    ingredients[newValue?.strIngredient16 ?? ""] = newValue?.strMeasure16
                    ingredients[newValue?.strIngredient17 ?? ""] = newValue?.strMeasure17
                    ingredients[newValue?.strIngredient18 ?? ""] = newValue?.strMeasure18
                    ingredients[newValue?.strIngredient19 ?? ""] = newValue?.strMeasure19
                    ingredients[newValue?.strIngredient20 ?? ""] = newValue?.strMeasure20
              
                }
            }

           
    }
    
    func fetchRecipeData() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i="+id) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(DessertsInfoData.self, from: data)
                if decodedData.meals.count > 0 {
                    self.info = decodedData.meals.first
                }
                self.loading = false
            }
            catch {
                print("Error decoding data: \(error)")
                self.loading = false
            }
            
        }.resume()
        
    }
}

struct IngredientsBox: View {
    @State var ingredients: [(String, String)]
    
    var body: some View {
        ScrollView{
            Text("Ingredients: ")
            ForEach(ingredients, id: \.0){ ingredient in
                Text("\(ingredient.0)")
            }
        }
    }
}

struct DessertsInfoData: Decodable {
    var meals: [RecipeInfo]
}

struct DessertsListData: Decodable {
    var meals: [DessertItem]
}

struct DessertItemData: Decodable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

/**
 * Recipe item container that holds the thumbnail image and recipe name
 */
struct DessertItem: View, Identifiable, Decodable{
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
    var id: String {
        self.idMeal
    }
    
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
              
                  
                }.padding(.horizontal, 30)
                    .padding(.vertical, 5)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RecipeInfo: Decodable, Equatable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    let strIngredient1: String
    let strIngredient2: String
    let strIngredient3: String
    let strIngredient4: String
    let strIngredient5: String
    let strIngredient6: String
    let strIngredient7: String
    let strIngredient8: String
    let strIngredient9: String
    let strIngredient10: String
    let strIngredient11: String
    let strIngredient12: String
    let strIngredient13: String
    let strIngredient14: String
    let strIngredient15: String
    let strIngredient16: String
    let strIngredient17: String
    let strIngredient18: String
    let strIngredient19: String
    let strIngredient20: String
    let strMeasure1: String
    let strMeasure2: String
    let strMeasure3: String
    let strMeasure4: String
    let strMeasure5: String
    let strMeasure6: String
    let strMeasure7: String
    let strMeasure8: String
    let strMeasure9: String
    let strMeasure10: String
    let strMeasure11: String
    let strMeasure12: String
    let strMeasure13: String
    let strMeasure14: String
    let strMeasure15: String
    let strMeasure16: String
    let strMeasure17: String
    let strMeasure18: String
    let strMeasure19: String
    let strMeasure20: String
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    static func == (left: RecipeInfo, right: RecipeInfo) -> Bool {
        return left.idMeal == right.idMeal
    }
}
