This is a project exploring a new sorting algorithm, that we have decided to call phase sort. It was invented by Jordan Lamkin and Timothy Reynolds in 2016.

The algorithm is a merge-style in-place sort, the idea behind it being to first split the input into even and odd indicies, sort each of those sub-arrays, then combine both sorted sub-arrays into a singular sorted array. The naive algorithm does this recursivly. This sort is not stable.

This repository contains both a recursive and non-recursive implementation of the algorithm written in both C and assembly. It compares timings of all 4 implementations, and the main file can be easily tuned for multiple different sizes of arrays.
