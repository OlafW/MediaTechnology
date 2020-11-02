import copy

def convert_to_ml(r):
  recipes = copy.deepcopy(r)

  for recipe in recipes:
      ingredients = recipe['ingredients']

      for ingredient in ingredients:
          unit = ingredient['unit']
          amount = float(ingredient['amount'])

          if unit == 'cup':
              amount *= 236.6
          elif unit == 'tsp':
              amount *= 4.9
          elif unit == 'tbsp':
              amount *= 14.8
          elif unit == 'eggs':
              amount *= 45.0

          ingredient['amount'] = amount

  return recipes


def convert_from_ml(r):
  recipes = copy.deepcopy(r)

  for rr in recipes:
      recipe = copy.deepcopy(rr)
      ingredients = recipe['ingredients']

      for ingredient in ingredients:
        unit = ingredient['unit']
        amount = ingredient['amount']

        if unit == 'cup':
            amount /= 236.6
        elif unit == 'tsp':
            amount /= 4.9
        elif unit == 'tbsp':
            amount /= 14.8
        elif unit == 'eggs':
            amount /= 45.0

        ingredient['amount'] = amount

      rr = copy.deepcopy(recipe)

  return recipes


def normalise_ml(r, norm_yield):
  recipes = copy.deepcopy(r)

  for recipe in recipes:
    ingredients = recipe['ingredients']

    for ingredient in ingredients:
      ingredient['amount'] *= norm_yield / recipe['yield']

  return recipes


def avg_class_ratio(recipes):
  num_class = 5
  avg_class_ratio = [['base', 0], ['binding', 0],
                      ['rising', 0], ['flavour', 0], ['topping', 0]]

  for recipe in recipes:
    ingredients = recipe['ingredients']

    total_weight = sum(i['amount'] for i in ingredients)

    # sum up weight for every class
    for i in ingredients:
        for c in avg_class_ratio:
          if i['class'] == c[0]:
            c[1] += i['amount'] / total_weight

  for c in avg_class_ratio:
    c[1] /= len(recipes)

  return avg_class_ratio
