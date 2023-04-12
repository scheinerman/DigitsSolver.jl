# `DigitsSolver`
Solve *New York Times* [digits puzzles](https://www.nytimes.com/games/digits).

For example, here is how to solve this puzzle:

<p align="center">
    <img src="digits-example.png" alt= “” width="451" height="422">
</p>

```
julia> using DigitsSolver

julia> digits_solver(264, [4,5,6,7,9,25])
[4, 5, 6, 7, 9, 25] → 25 × 6 = 150 → [4, 5, 7, 9, 150]
[4, 5, 7, 9, 150] → 9 × 4 = 36 → [5, 7, 36, 150]
[5, 7, 36, 150] → 7 - 5 = 2 → [2, 36, 150]
[2, 36, 150] → 150 × 2 = 300 → [36, 300]
[36, 300] → 300 - 36 = 264 → [264]
```

See also [this code](https://github.com/scheinerman/TwentyFour.jl) for solving Twenty Four puzzles.

## To Do

Give a sensible output if there is no solution.