# landscape-passing-opportunities
This repository contains the code associated to a manuscript submitted to Scientific Reports Nature - Open Access Journal:

"Changes in landscapes of passing opportunities along a set of competitive football matches."<br/>
Luis Gómez-Jordana<sup>1</sup>, Rodrigo Amaro e Silva<sup>2</sup>, João Milho<sup>3</sup>, Angel Ric<sup>4</sup>, Pedro Passos<sup>1</sup>

<sup>1</sup>CIPER, Faculdade de Motricidade Humana, Universidade de Lisboa (Portugal)<br/>
<sup>2</sup>Instituto Dom Luiz, Faculdade de Ciências, Universidade de Lisboa (Portugal)<br/>
<sup>3</sup>CIMOSM, Instituto Superior de Engenharia de Lisboa, Instituto Politécnico de Lisboa (Portugal)<br/>
<sup>4</sup>Complex Systema in Sport Research Group, Institut Nacional d’Educacio Fisica de Catalunya, University of Lleida (Spain)<br/>

The developed code ingests positional data from a soccer match and evaluates passing opportunities and possible interceptions from defenders, creating two main deliverables:<
- videos highlighting passing opportunities and the potential action of opposing players
- a heatmap which accumulates the regions where most passing opportunities occurred

The data included in this repository corresponds to a match from the 2nd Spanish professional division, 2017-18 season.

Due to data privacy issues, a few constraints had to be considered:
- the name of the teams and players involved in the match were removed
- only the first two minutes of the game, which include two offensive plays, are made available

The "main" branch presents a fully-working code. However, an "improv" branch will focus on improving code readability and efficiency, aiming for less written code, more explanatory comments, and faster/less demanding calculations.
