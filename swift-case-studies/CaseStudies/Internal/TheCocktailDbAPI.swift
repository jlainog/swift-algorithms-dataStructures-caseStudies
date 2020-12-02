import Foundation

enum TheCocktailDbAPI {
    struct DrinkDetail: Codable {
        var id: String
        var name: String
        var category: String
        var instructions: String
        var thumb: String?
        var thumbURL: URL? {
            guard let thumb = self.thumb else { return nil }
            return URL(string: thumb)
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "idDrink"
            case name = "strDrink"
            case category = "strCategory"
            case instructions = "strInstructions"
            case thumb = "strDrinkThumb"
        }
    }
    
    struct Drink: Codable {
        var id: String
        var name: String
        var thumb: String?
        var thumbURL: URL? {
            guard let thumb = self.thumb else { return nil }
            return URL(string: thumb)
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "idDrink"
            case name = "strDrink"
            case thumb = "strDrinkThumb"
        }
    }
    
    struct List: Codable {
        var drinks: [Drink]
    }
    
    static func fetchAlcoholicDrinks(completionHandler: @escaping (Result<List, Error>) -> Void) {
        URLSession.shared.dataTask(
            with: URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic")!
        ) { (data, urlResponse, requestError) in
            guard let data = data else {
                completionHandler(.failure(requestError!))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(List.self, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(error))
            }
        }
        .resume()
    }
}

extension TheCocktailDbAPI.Drink {
    static let FiftySevenChevy = Self(
        id: "14029",
        name: "'57 Chevy with a White License Plate",
        thumb: "https://www.thecocktaildb.com/images/media/drink/qyyvtu1468878544.jpg"
    )
}

extension TheCocktailDbAPI.DrinkDetail {
    static let eggNog = Self(
        id: "12914",
        name: "Egg-Nog - Classic Cooked",
        category: "Punch / Party Drink",
        instructions: """
        In large saucepan, beat together eggs, sugar and salt, if desired. Stir in 2 cups of the milk. Cook over low heat, stirring constantly, until mixture is thick enough to coat a metal spoon and reaches 160 degrees F. Remove from heat. Stir in remaining 2 cups milk and vanilla. Cover and regfigerate until thoroughly chilled, several hours or overnight. Just before serving, pour into bowl or pitcher. Garnish or add stir-ins, if desired. Choose 1 or several of: Chocolate curls, cinnamon sticks, extracts of flavorings, flavored brandy or liqueur, fruit juice or nectar, ground nutmeg, maraschino cherries, orange slices, peppermint sticks or candy canes, plain brandy, run or whiskey, sherbet or ice-cream, whipping cream, whipped. Serve immediately.
        """
    )
}
