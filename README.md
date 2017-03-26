# Emergency Response Unit Locator using Genetic Algorithm
Finds the best location for an Emergency Response Unit using Genetic Algorithm.

The problem is an excerpt from the book, [Practical Genetic Algorithms, 2nd Ed.](https://www.researchgate.net/profile/Sue_Haupt/publication/37405956_Practical_Genetic_Algorithms/links/0912f5092a761d8b04000000/Practical-Genetic-Algorithms.pdf) 
by Randy L. Hapt and Sue Ellen Hapt.

Given a 10x10 km city, the goal is to find the most efficient location in which it can serve all the locations within the city
once emergency happens. For each location, a numerical value represents the fire frequency for that location after a survey of past emergencies. [[1]]

> The response time of the fire station is estimated be 1.7 + 3.4r minutes, where r is in
kilometers. This formula is not based on real data, but an actual city would have an
estimate of this formula based on traffic, time of day and so on.  [[1]]

![](https://github.com/raymelon/EmergencyResponseUnitLocator/blob/master/misc/model.JPG)

***Figure:** A model of 10x10 km city divided into 100 equal squares.*  [[1]]

## Genetic Algorithm Design

### Cost Function
Following the suggested cost function on the book, the cost function will be

![](https://github.com/raymelon/EmergencyResponseUnitLocator/blob/master/misc/cost.JPG)  [[1]]


### Genetic Operators
- Selection 

    Using Truncation Selection, the most efficient location will be found right at generation 1.
    A simpler approach in solving this problem is to evaluate all the locations, then sort them by efficiency.
    Since Truncation Selection uses sorting, it makes sense that it will get the best location right at generation 1.


- Crossover 

    One-Point Crossover, since `xs` and `ys` are the only values to be interchanged between parents.

- Mutation 

    Swap Mutation, since `xs` and `ys` are the only values to be swapped on the child.

# References
[1]: RG ""
[\[1\] RL Haupt and SE Haupt, *PRACTICAL GENETIC ALGORITHMS.* Hoboken, New Jersey, USA: John Wiley & Sons, Inc., 2004.](https://www.researchgate.net/profile/Sue_Haupt/publication/37405956_Practical_Genetic_Algorithms/links/0912f5092a761d8b04000000/Practical-Genetic-Algorithms.pdf)


