# Day 24 Solution (Pen and Paper)

I found this challenge a lot easier to do on pen and paper, so I decided not to write a program for it. I might have been fortunate and got an easy question, but I am going to write down my logic here anyways.

So, our main target is to reduce the movement of the heaviest instances (C & D) as much as possible. 

Given input:

```
#############
#...........#
###C#A#B#C###
  #D#D#B#A#
  #########
```

+ So first, we clear the path for the 'C' instances.

```
#############
#BB.........#
###C#A#.#C###
  #D#D#.#A#
  #########
```

This leaves us with:
`A = 0; B = 14; C = 0; D = 0`.

+ Next, we move the C's to their homes.

```
#############
#BB.........#
###.#A#C#.###
  #D#D#C#A#
  #########
 ```

This leaves us with:
`A = 0; B = 14; C = 11; D = 0`.

+ Now, we move the A away to make way for D's.

```
#############
#BB.......A.#
###.#A#C#.###
  #D#D#C#.#
  #########
 ```

This leaves us with:
`A = 3; B = 14; C = 11; D = 0`

+ Now, we move the first D in.

```
#############
#BB.......A.#
###.#A#C#.###
  #.#D#C#D#
  #########
 ```

This leaves us with:
`A = 3; B = 14; C = 11; D = 10`.

+ We move the A's in.

```
#############
#BB.........#
###A#.#C#.###
  #A#D#C#D#
  #########
 ```

This leaves us with:
`A = 16; B = 14; C = 11; D = 10`.

+ We move the second D in.

```
#############
#BB.........#
###A#.#C#D###
  #A#.#C#D#
  #########
 ```

This leaves us with:
`A = 16; B = 14; C = 11; D = 17`.

+ We move the B's in.

```
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########
 ```

This leaves us with:
`A = 16; B = 24; C = 11; D = 17`.

---

+ We see that all our characters are at their respective homes. We now multiply the costs and add.


```
A (1) = 16;
B (10) = 240;
C (100) = 1100;
D (1000) = 17000;

Sum = 18356 (18360 with another algorithm.) (18618 with another algorithm.)
```

Thanks!