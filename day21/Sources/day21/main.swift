import Foundation

struct Food {
    let ingredients: Set<String>
    let allergens: Set<String>
}

extension Food {
    init?<S: StringProtocol>(_ source: S) {
        guard let parenIdx = source.firstIndex(of: "(") else { return nil }

        let ingredientStr = source[..<parenIdx].trimmingCharacters(in: .whitespaces)
        self.ingredients = Set(ingredientStr.components(separatedBy: " "))

        let allergenStr = source[parenIdx...].dropFirst("(contains ".count).dropLast()
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
                possibleAllergen.remove(allergen)
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
        for ingredient in food.ingredients.subtracting(inertIngredients) {
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

func findDangerousIngredientsByAllergen() -> [String: String] {
    var result = [String: String]()

    let allergenCount = foods.reduce(into: Set<String>()) { $0.formUnion($1.allergens) }.count

    let foodCountByAllergen: [String: Int] = foods.reduce(into: [:]) { result, food in
        for allergen in food.allergens {
            result[allergen, default: 0] += 1
        }
    }

    while result.count != allergenCount {
        for (allergen, ingredientCounts) in ingredientCountsByAllergen {
            for (ingredient, count) in ingredientCounts {
                if count != foodCountByAllergen[allergen] {
                    ingredientCountsByAllergen[allergen]?[ingredient] = nil
                }
            }
            if ingredientCountsByAllergen[allergen]?.count == 1, let ingredient = ingredientCountsByAllergen[allergen]?.keys.first {
                result[allergen] = ingredient
                removeIngredient(ingredient)
            }
        }
    }
    return result
}

let dangerousIngredientsByAllergen = findDangerousIngredientsByAllergen()
let dangerousIngredientsList = dangerousIngredientsByAllergen.sorted { $0.key < $1.key }.map(\.value).joined(separator: ",")
print(dangerousIngredientsList) // kbdgs,sqvv,slkfgq,vgnj,brdd,tpd,csfmb,lrnz
