[inputs] | join(",")/",," | map(./"," | map(./""))
| reduce {"^": [-1, 0], ">": [0, 1], "v": [1, 0], "<": [0, -1]}[.[1][][]] as [$dy, $dx] (
  .[0] | {s: paths(. == "@"), m: .};
  .m as $m
  | (.s + ["O"] | until(.[2] != "O"; .[0] += $dy | .[1] += $dx | .[2] = $m[.[0]][.[1]])) as [$y, $x, $t]
  | if $t != "#" then
    .s[0] += $dy | .s[1] += $dx
    | .m[$y][$x] = .m[.s[0]][.s[1]]
    | .m[.s[0]][.s[1]] = "."
  end
)
| .m | [paths(. == "O") | .[0] * 100 + .[1]] | add
