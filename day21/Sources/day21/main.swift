import Foundation

struct Food {
    let ingredients: Set<String>
    let allergens: Set<String>
}

extension Food {
    init?<S: StringProtocol>(_ source: S) {
        guard let parenIdx = source.firstIndex(of: "(") else { return nil }

        let ingredientStr = source[..<parenIdx].dropLast()
        self.ingredients = Set(ingredientStr.components(separatedBy: " "))

        let allergenStr = source[parenIdx...].dropLast().dropFirst("(contains ".count)
        allergens = Set(allergenStr.components(separatedBy: ", "))
    }
}

let foods = input.split(separator: "\n").compactMap(Food.init)

func isInert(_ ingredient: String) -> Bool {
    var impossibleAllergen: Set<String> = []
    var possibleAllergen: Set<String> = []

    for food in foods {
        if food.ingredients.contains(ingredient) {
            for allergen in food.allergens {
                if !impossibleAllergen.contains(allergen) {
                    possibleAllergen.insert(allergen)
                }
            }
        } else {
            for allergen in food.allergens {
                impossibleAllergen.insert(allergen)
                if possibleAllergen.contains(allergen) {
                    possibleAllergen.remove(allergen)
                }
            }
        }
    }
    return possibleAllergen.isEmpty
}

let allIngredients = foods.flatMap(\.ingredients)
let ingredientsSet = Set(allIngredients)
let inertIngredients = Set(ingredientsSet.filter(isInert))

let inertIngredientCount = allIngredients.filter(inertIngredients.contains).count
print("answer to part one: \(inertIngredientCount)") // 2317

// doesn't contain known inert ingredients
var ingredientCountsByAllergen: [String: [String: Int]] = foods.reduce(into: [:]) { result, food in
    for allergen in food.allergens {
        var ingredientCounts = result[allergen, default: [:]]
        for ingredient in food.ingredients where !inertIngredients.contains(ingredient) {
            ingredientCounts[ingredient, default: 0] += 1
        }
        result[allergen] = ingredientCounts
    }
}

func removeIngredient(_ ingredient: String) {
    for allergen in ingredientCountsByAllergen.keys {
        ingredientCountsByAllergen[allergen]?[ingredient] = nil
        if ingredientCountsByAllergen[allergen]?.isEmpty == true {
            ingredientCountsByAllergen[allergen] = nil
        }
    }
}

let foodCountByAllergen: [String: Int] = foods.reduce(into: [:]) { result, food in
    for allergen in food.allergens {
        result[allergen, default: 0] += 1
    }
}

let allergenCount = foods.reduce(into: Set<String>()) { $0.formUnion($1.allergens) }.count

var dangerousIngredientByAllergen = [String: String]()
while dangerousIngredientByAllergen.count != allergenCount {
    for (allergen, ingredientCounts) in ingredientCountsByAllergen {
        for (ingredient, count) in ingredientCounts {
            if count != foodCountByAllergen[allergen] {
                ingredientCountsByAllergen[allergen]?[ingredient] = nil
            }
        }
        if ingredientCountsByAllergen[allergen]?.count == 1, let ingredient = ingredientCountsByAllergen[allergen]?.keys.first {
            dangerousIngredientByAllergen[allergen] = ingredient
            removeIngredient(ingredient)
        }
    }
}

let dangerousIngredientList = dangerousIngredientByAllergen.sorted { $0.key < $1.key }.map(\.value).joined(separator: ",")
print(dangerousIngredientList) // kbdgs,sqvv,slkfgq,vgnj,brdd,tpd,csfmb,lrnz
