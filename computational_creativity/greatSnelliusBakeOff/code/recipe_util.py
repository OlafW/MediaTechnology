# import json

def convert_to_ml(recipes):
    for recipe in recipes:
        ingredients = recipe['ingredients']

        for ingredient in ingredients:
            unit = ingredient['unit']
            amount = ingredient['amount']

            if (unit == "cup"):
                amount *= 236.6
            elif (unit == "tsp"):
                amount *= 4.9
            elif (unit == "tbsp"):
                amount *= 14.8
            elif (unit == "eggs"):
                amount *= 45

            ingredient['amount'] = amount

    return recipes

def convert_from_ml(recipes):
    for recipe in recipes:
        ingredients = recipe['ingredients']

        for ingredient in ingredients:
            unit = ingredient['unit']
            amount = ingredient['amount']

            if (unit == "cup"):
                amount /= 236.6
            elif (unit == "tsp"):
                amount /= 4.9
            elif (unit == "tbsp"):
                amount /= 14.8
            elif (unit == "eggs"):
                amount /= 45

            ingredient['amount'] = amount

    return recipes


def normalise_ml(recipes, norm_cookies=10):
  for recipe in recipes:
    ingredients = recipe['ingredients']

    for ingredient in ingredients:
      ingredient['amount'] *= norm_cookies / recipe['num_cookies']

  return recipes
