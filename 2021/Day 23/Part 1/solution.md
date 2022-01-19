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

+ So first, we clear the path for the right 'C' instance.

```
#############
#.B.B.......#
###C#A#.#C###
  #D#D#.#A#
  #########
```

This leaves us with:
`A = 0; B = 11; C = 0; D = 0`.

+ Next, we move the right C's to its home.

```
#############
#.B.B.......#
###C#A#.#.###
  #D#D#C#A#
  #########
 ```

This leaves us with:
`A = 0; B = 11; C = 5; D = 0`.

+ Now, we move the A away to make way for D's.

```
#############
#.B.B.....AA#
###C#.#.#.###
  #D#D#C#.#
  #########
 ```

This leaves us with:
`A = 10; B = 11; C = 5; D = 0`

+ Now, we move the first D in.

```
#############
#.B.B.....AA#
###C#.#.#.###
  #D#.#C#D#
  #########
 ```

This leaves us with:
`A = 10; B = 11; C = 5; D = 8`.

+ We move the B's in.

```
#############
#.........AA#
###C#B#.#.###
  #D#B#C#D#
  #########
 ```

This leaves us with:
`A = 10; B = 18; C = 5; D = 8`.

+ We move the second C and second D in.

```
#############
#.........AA#
###.#B#C#D###
  #.#B#C#D#
  #########
 ```

This leaves us with:
`A = 10; B = 18; C = 11; D = 17`.

+ Finally, we move the A's in.

```
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########
 ```

This leaves us with:
`A = 16+18 = 34 ; B = 18; C = 11; D = 17`.

---

last state: `A = 16; B = 24; C = 11; D = 17`.


+ We see that all our characters are at their respective homes. We now multiply the costs and add.


```
A (1) = 34;
B (10) = 180;
C (100) = 1100;
D (1000) = 17000;

Sum = 18314 (18356 with another algorithm.) (18360 with another algorithm.) (18618 with another algorithm.)
```

Thanks!