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

// part 1

func isInert(_ ingredient: String) -> Bool {
    var impossibleAllergen: Set<String> = []
    var possibleAllergen: Set<String> = []

    for food in foods {
        if food.ingredients.contains(ingredient) {
            possibleAllergen.formUnion(food.allergens.subtracting(impossibleAllergen))
        } else {
            impossibleAllergen.formUnion(food.allergens)
            possibleAllergen.subtract(food.allergens)
        }
    }
    return possibleAllergen.isEmpty
}

func findInertIngredients() -> Set<String> {
    let allIngredients = foods.flatMap(\.ingredients)
    let inertIngredients = Set(Set(allIngredients).filter(isInert))

    let count = allIngredients.filter(inertIngredients.contains).count
    print("answer to part one: \(count)") // 2317

    return inertIngredients
}

let inertIngredients = findInertIngredients()

// part 2

func removeIngredient(_ ingredient: String, from dict: inout [String: [String: Int]]) {
    for allergen in dict.keys {
        dict[allergen]?[ingredient] = nil
        if dict[allergen]?.isEmpty == true {
            dict[allergen] = nil
        }
    }
}

func findDangerousIngredients() -> [String: String] {
    var result = [String: String]()

    let foodCountByAllergen: [String: Int] = foods.reduce(into: [:]) { result, food in
        for allergen in food.allergens {
            result[allergen, default: 0] += 1
        }
    }

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

    let allergenCount = foods.reduce(into: Set<String>()) { $0.formUnion($1.allergens) }.count
    while result.count != allergenCount {
        for (allergen, ingredientCounts) in ingredientCountsByAllergen {
            for (ingredient, count) in ingredientCounts {
                if count != foodCountByAllergen[allergen] {
                    ingredientCountsByAllergen[allergen]?[ingredient] = nil
                }
            }
            if ingredientCountsByAllergen[allergen]?.count == 1, let ingredient = ingredientCountsByAllergen[allergen]?.keys.first {
                result[allergen] = ingredient
                removeIngredient(ingredient, from: &ingredientCountsByAllergen)
            }
        }
    }
    return result
}

let dangerousIngredients = findDangerousIngredients().sorted { $0.key < $1.key }.map(\.value).joined(separator: ",")
print(dangerousIngredients) // kbdgs,sqvv,slkfgq,vgnj,brdd,tpd,csfmb,lrnz
