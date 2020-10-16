import json
import pprint
import random
import math
from collections import Counter
import recipe_unit_convert

recipefile = 'data/recipes.json'
with open(recipefile) as json_file:
    data = json.load(json_file)


# convert the units in the recipe to mL
data = recipe_unit_convert.convert_to_ml(data)

recipes = data['recipes']

"""To check what we have loaded we can use the pretty printing library (pprint)."""

# pprint.PrettyPrinter(indent=2, depth=3).pprint(recipes[0])

"""Next we extract all of the ingredients from the recipes, so that we can use them in mutation operators."""

all_ingredients = []
for recipe in recipes:
  all_ingredients.extend(recipe['ingredients'])

"""To check on the complete list of ingredients, we can use the pprint library to provide formatted list."""

#pprint.PrettyPrinter(indent=2, depth=2).pprint(all_ingredients)

"""## Creating an Initial Population

Now we can create an initial population, by first defining the population size and then selecting from the list of recipes.
"""

population_size = 20

population = random.choices(recipes, k=population_size)

"""And we can check on the recipes that were selected in the initial population."""

#pprint.PrettyPrinter(indent=2, depth=2).pprint(population)

"""## Evaluating Recipes (Fitness Function)

The following function defines how individuals are evaluated:
"""


def evaluate_recipes(recipes):
  # amount of occurences for every unique ingredient
  ingredients_weighted = Counter([ingredients['ingredient'] for ingredients in all_ingredients])

  recipe_weighted = [0] * len(recipes)

  for recipe in recipes:
    recipe['fitness'] = 0
    ingredients = recipe['ingredients']

    for ingredients in ingredients:
      r_i = ingredients['ingredient']
      recipe['fitness'] += ingredients_weighted[r_i]-1

    # recipe['fitness'] /= len(ingredients_weighted)

  # fitness is the amount of ingredients that also appear in other recipes
  print([recipe['fitness'] for recipe in recipes])

"""We can use this to evaluate the initial population."""

evaluate_recipes(population)
population = sorted(population, reverse = True, key = lambda r: r['fitness'])

#pprint.PrettyPrinter(indent=2, depth=2).pprint(population)

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

"""## Genetic Operators

The following functions implement the genetic operators of crossover and mutation. Crossover takes two recipes and combines them by choosing a point on each genotype (recipe) to split each list into two, and joining the first sublist from one genotype with the second sublist of the second genotype.
"""

recipe_number = 1

def crossover_recipes(r1, r2):
  global recipe_number
  p1 = random.randint(1, len(r1['ingredients'])-1)
  p2 = random.randint(1, len(r2['ingredients'])-1)
  r1a = r1['ingredients'][0:p1]
  r2b = r2['ingredients'][p2:-1]
  r = dict()
  r['name'] = "recipe {}".format(recipe_number)
  recipe_number += 1
  r['ingredients'] = r1a + r2b
  return r

"""The mutation operator changes a recipe using one of four different types of mutations: (1) changing the amount of an ingredient, (2) changing the type of an ingredient, (3) adding an ingredient, and (4) removing an ingredient."""

def mutate_recipe(r):
  m = random.randint(0, 3)
  if m == 0:
    i = random.randint(0, len(r['ingredients'])-1)
    r['ingredients'][i] = r['ingredients'][i].copy()
    r['ingredients'][i]['amount'] += math.floor(r['ingredients'][i]['amount'] * 0.1)
    r['ingredients'][i]['amount'] = max(1, r['ingredients'][i]['amount'])
  elif m == 1:
    j = random.randint(0, len(r['ingredients'])-1)
    r['ingredients'][j] = r['ingredients'][j].copy()
    r['ingredients'][j]['ingredient'] = random.choice(all_ingredients)['ingredient']
  elif m == 2:
    r['ingredients'].append(random.choice(all_ingredients).copy())
  else:
    if len(r['ingredients']) > 1:
      r['ingredients'].remove(random.choice(r['ingredients']))

"""The following function is domain-specific and normalises a generated recipe by removing duplicate ingredients (combining the amounts of all instances of an ingredient) and rescaling the volume of ingredients listed to 1 litre (1000 units)."""

def normalise_recipe(r):
  unique_ingredients = dict()
  for i in r['ingredients']:
    if i['ingredient'] in unique_ingredients:
      n = unique_ingredients[i['ingredient']]
      n['amount'] += i['amount']
    else:
      unique_ingredients[i['ingredient']] = i.copy()
  r['ingredients'] = list(unique_ingredients.values())

  sum_amounts = sum([i['amount'] for i in r['ingredients']])
  scale = 1000 / sum_amounts
  for i in r['ingredients']:
    i['amount'] = max(1, math.floor(i['amount'] * scale))

"""## Generating Recipes

We use the above functions to generate recipes.
"""

def generate_recipes(size, population):
  R = []
  while len(R) < size:
    r1 = select_recipe(population)
    r2 = select_recipe(population)
    r = crossover_recipes(r1, r2)
    mutate_recipe(r)
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

"""## Putting it All Together...

To run the genetic algorithm, we repeat here the code to set up and evaluated an initial population, before running the evolutionary process for a number of steps.
"""

population = random.choices(recipes, k=population_size)
evaluate_recipes(population)
population = sorted(population, reverse = True, key = lambda r: r['fitness'])

max_fitnesses = []
min_fitnesses = []

num_runs = 1

for i in range(num_runs):
  R = generate_recipes(population_size, population)
  population = select_population(population, R)
  max_fitnesses.append(population[0]['fitness'])
  min_fitnesses.append(population[-1]['fitness'])

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

"""Finally, because the recipe is always sorted according to fitness, the fittest individual will be the one in the first position, so we can print this out."""

#pprint.PrettyPrinter(indent=2, depth=3).pprint(population[0])
