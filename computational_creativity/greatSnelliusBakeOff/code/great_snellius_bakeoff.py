import json
import pprint
import random
import math
import numpy as np
from collections import Counter
import recipe_util

recipefile = 'data/recipes.json'
with open(recipefile) as json_file:
    data = json.load(json_file)

# convert the units in the recipe to mL
recipes = data['recipes']
recipes = recipe_util.convert_to_ml(recipes)
# pprint.PrettyPrinter(indent=2, depth=4).pprint(recipes)


#normalise recipes
norm_yield = 25
recipes = recipe_util.normalise_ml(recipes, norm_yield)
# pprint.PrettyPrinter(indent=2, depth=4).pprint(recipes)

# All ingredient classes and their average weighting (%)
avg_class_ratio = recipe_util.avg_class_ratio(recipes)
num_class = len(avg_class_ratio)
# pprint.PrettyPrinter(indent=2, depth=4).pprint(avg_class_ratio)


# All ingredients and weighted unique ingredients
all_ingredients = []
for recipe in recipes:
  all_ingredients.extend(recipe['ingredients'])

ingredients_weighted = Counter([ingredients['ingredient'] for ingredients in all_ingredients])



"""## Evaluating Recipes (Fitness Function)

The following function defines how individuals are evaluated:
"""

def evaluate_recipes(recipes):
  # Fitness is based on:
  #   - recipe similarity
  #   - recipe ingredient ratio
  #   - novelty: unique ingredient combinations

  recipe_similarity = [0] * len(recipes)
  recipe_ratio = [0] * len(recipes)
  recipe_novelty = [0] * len(recipes)

  # - Recipe similarity
  # amount of occurences for every unique ingredient

  for r in range(len(recipes)):
    recipe = recipes[r]
    ingredients = recipe['ingredients']

    for ingredient in ingredients:
      r_i = ingredient['ingredient']
      recipe_similarity[r] += ingredients_weighted[r_i]-1

    recipe_similarity[r] = recipe_similarity[r] / len(all_ingredients)

  # - Recipe ingredient ratio
  for r in range(len(recipes)):
    recipe = recipes[r]
    ingredients = recipe['ingredients']

    class_weight = [0] * num_class
    total_weight = sum(i['amount'] for i in ingredients)

    # sum up weight for every class
    for i in ingredients:
        for c in range(num_class):
          if i['class'] == avg_class_ratio[c][0]:
            class_weight[c] += i['amount']

    for c in range(num_class):
      # class_weight[c] = 1 - abs(class_weight[c]/total_weight - avg_class_ratio[c][1])

      if class_weight[c] <= avg_class_ratio[c][1]:
        class_weight[c] /= avg_class_ratio[c][1]
      else:
        class_weight[c] = avg_class_ratio[c][1] / class_weight[c]

    recipe_ratio[r] = sum(class_weight) / num_class

  # print(recipe_ratio)

  # set the fitness for each recipe
  for r in range(len(recipes)):
    recipe = recipes[r]
    recipe['fitness'] = int((recipe_similarity[r] + recipe_ratio[r]) / 2 * 100.0)


# Calculate the mean and std for each unique ingredient
def get_mean_std_ingredient():
  n = len(ingredients_weighted)
  weight_document = [[] for i in range(n)]

  for i in all_ingredients:
      this_name = (i['ingredient'])
      index = list(ingredients_weighted).index(this_name)
      this_weight = i['amount']
      weight_document[index].append(this_weight)

  y=np.array([np.array(xi) for xi in weight_document])

  mean_list =[np.mean(i) for i in y]
  std_list =[np.std(i) for i in y]

  mean_std = list(zip(mean_list,std_list))

  return mean_std

mean_std = get_mean_std_ingredient()


"""## Selecting Recipes

The following function implements Roulette Wheel selection of individuals based on their fitness:
"""

def select_recipe(recipes):
  sum_fitness = sum([recipe['fitness'] for recipe in recipes])
  f = random.randint(0, sum_fitness)
  for recipe in recipes:
    if f < recipe['fitness']:
      return recipe
    f -= recipe['fitness']
  return recipes[-1]


"""## Genetic Operators"""

def crossover_recipes(r1, r2):
  global recipe_number
  p1 = random.randint(1, len(r1['ingredients'])-1)
  p2 = random.randint(1, len(r2['ingredients'])-1)
  r1a = r1['ingredients'][0:p1]
  r2b = r2['ingredients'][p2:-1]

  r = dict()
  r['ingredients'] = r1a + r2b
  r['yield'] = round((r1['yield'] + r2['yield']) / 2)

  return r

"""The mutation operator changes a recipe using one of four different types of mutations: (1) changing the amount of an ingredient, (2) changing the type of an ingredient, (3) adding an ingredient, and (4) removing an ingredient."""

def mutate_recipe(r, mean_std):
  m = random.randint(0, 3)

  if m == 0:
    i = random.randint(0, len(r['ingredients'])-1)
    r['ingredients'][i] = r['ingredients'][i].copy()

    this_name = r['ingredients'][i]['ingredient']
    index = list(ingredients_weighted).index(this_name)
    this_mean_std = mean_std[index]

    mu, sigma = this_mean_std[0], this_mean_std[1]
    s = np.random.normal(mu, sigma, 1)
    r['ingredients'][i]['amount'] = s[0]

  elif m == 1:   #change name
      j = random.randint(0, len(r['ingredients'])-1)
      r['ingredients'][j] = r['ingredients'][j].copy()

      random_int = random.randint(0, len(all_ingredients)-1)

      r['ingredients'][j]['ingredient'] = all_ingredients[random_int]['ingredient']
      # r['ingredients'][j]['role'] = all_ingredients[random_int]['role']
      r['ingredients'][j]['class'] = all_ingredients[random_int]['class']
      r['ingredients'][j]['unit'] = all_ingredients[random_int]['unit']

  elif m == 2:
    r['ingredients'].append(random.choice(all_ingredients).copy())

  else:
    if len(r['ingredients']) > 1:
      r['ingredients'].remove(random.choice(r['ingredients']))


# Combine same ingredients and normalise based on yield
def normalise_recipe(r):
  unique_ingredients = dict()

  for i in r['ingredients']:

    if i['ingredient'] in unique_ingredients:
      n = unique_ingredients[i['ingredient']]
      n['amount'] += i['amount']
    else:
      unique_ingredients[i['ingredient']] = i.copy()
  r['ingredients'] = list(unique_ingredients.values())

  for ingredient in r['ingredients']:
    # ingredient = i.copy()
    ingredient['amount'] *= norm_yield / r['yield']

  # sum_amounts = sum([i['amount'] for i in r['ingredients']])
  # scale = 1000 / sum_amounts
  #
  # for i in r['ingredients']:
  #   i['amount'] = max(1, math.floor(i['amount'] * scale))



"""## Generating Recipes

We use the above functions to generate recipes.
"""

def generate_recipes(size, population):
  R = []

  while len(R) < size:
    r1 = select_recipe(population)
    r2 = select_recipe(population)
    r = crossover_recipes(r1, r2)
    mutate_recipe(r, mean_std)
    normalise_recipe(r)
    R.append(r)
  evaluate_recipes(R)
  return R

"""## Selecting a New Population

The final function that we need to implement is one that selects a new population given the previous population and the generated recipes.
"""

def select_population(P, R):
  R = sorted(R, reverse = True, key = lambda r: r['fitness'])
  P = P[0:len(P)//2] + R[0:len(R)//2]
  P = sorted(P, reverse = True, key = lambda r: r['fitness'])
  return P

def generate_recipe_names(recipes):
  for r in recipes:
    max_flavour = 0
    max_topping = 0

    flavour_name = ' '
    topping_name = ' '

    for ingredient in r['ingredients']:
      if ingredient['class'] == 'flavour':
        if ingredient['amount'] >= max_flavour:
          max_flavour = ingredient['amount']
          flavour_name = ingredient['ingredient']

      elif ingredient['class'] == 'topping':
        if ingredient['amount'] >= max_topping:
          max_topping = ingredient['amount']
          topping_name = ingredient['ingredient']

    r['name'] = flavour_name + ' ' + topping_name

  return recipes

"""## Putting it All Together...

To run the genetic algorithm, we repeat here the code to set up and evaluated an initial population, before running the evolutionary process for a number of steps.
"""

population_size = 20
population = random.choices(recipes, k=population_size)
evaluate_recipes(population)
population = sorted(population, reverse = True, key = lambda r: r['fitness'])

max_fitnesses = []
min_fitnesses = []

num_runs = 1000

for i in range(num_runs):
  R = generate_recipes(population_size, population)
  population = select_population(population, R)
  max_fitnesses.append(population[0]['fitness'])
  min_fitnesses.append(population[-1]['fitness'])


# Convert back from amount in ml to original amount


# Generate recipe names
population = generate_recipe_names(population)
# print([p['name'] for p in population])

"""We can check on the progress of the evolution by plotting the fitness history we captured above. Here we plot both the maximum fitness each population and the range fitnesses (filling between max fitness and min fitness)."""

import matplotlib.pyplot as plt

x  = range(num_runs)
plt.plot(x, max_fitnesses, label="line L")
plt.fill_between(x, min_fitnesses, max_fitnesses, alpha=0.2)
plt.plot()

plt.xlabel("generation")
plt.ylabel("fitness")
plt.title("fitness over time")
plt.legend()
plt.show()

print("Generated recipe: ", population[0]['name'], '\n')
r_ingredients = population[0]['ingredients']
pprint.sorted = lambda x, key=None: x


pprint.PrettyPrinter(indent=2, depth=4).pprint(population[0])
print()
population = recipe_util.convert_from_ml(population)

pprint.PrettyPrinter(indent=2, depth=4).pprint(population[0])
