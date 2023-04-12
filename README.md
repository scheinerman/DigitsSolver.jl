# `DigitsSolver`
Solve *New York Times* [digits puzzles](https://www.nytimes.com/games/digits).

For example, here is how to solve this puzzle:

<p align="center">
    <img src="digits-example.png" alt= “” width="451" height="422">
</p>

```
julia> using DigitsSolver

julia> digits_solver(264, [4,5,6,7,9,25])
[4, 5, 6, 7, 9, 25] → 25 + 5 = 30 → [4, 6, 7, 9, 30]
[4, 6, 7, 9, 30] → 30 × 9 = 270 → [4, 6, 7, 270]
[4, 6, 7, 270] → 270 - 6 = 264 → [4, 7, 264]
```

In case no answer exists:
```
julia> digits_solver(200,1:5)
No solution

julia> digits_solver(200,1:6)
[1, 2, 3, 4, 5, 6] → 4 + 3 = 7 → [1, 2, 5, 6, 7]
[1, 2, 5, 6, 7] → 7 × 6 = 42 → [1, 2, 5, 42]
[1, 2, 5, 42] → 42 ÷ 1 = 42 → [2, 5, 42]
[2, 5, 42] → 42 - 2 = 40 → [5, 40]
[5, 40] → 40 × 5 = 200 → [200]
```

See also [this code](https://github.com/scheinerman/TwentyFour.jl) for solving Twenty Four puzzles.
