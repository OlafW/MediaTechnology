import json

def convert_to_ml(data):
    recipes = data['recipes']
    target_unit = 'ml'

    for recipe in recipes:
        ingredients = recipe['ingredients']

        for ingredient in ingredients:
            unit = ingredient['unit']
            amount = ingredient['amount']

            if (unit == "cup"):
                amount = amount * 236.6
                ingredient['unit'] = target_unit

            elif (unit == "tsp"):
                amount = amount * 4.9
                ingredient['unit'] = target_unit

            elif (unit == "tbsp"):
                amount = amount * 14.8
                ingredient['unit'] = target_unit

            ingredient['amount'] = amount

    return data

if __name__ == "__main__":
  infile='data/recipes.json'
  outfile='data/recipes_converted.json'

  with open (infile) as f:
      data = json.load(f)

  data = convert_to_ml(data)

  with open(outfile, 'w') as f:
      json.dump(data, f, indent=4)
