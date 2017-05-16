# Swambda

Swambda is a minimalistic interpreter for the untyped λ-calculus,
mainly for educational purposes.

## Usage

The command `Swambda -e <term>` will show the successive β-reductions one can apply on `term`
before it reaches an irreducible form.
For instance, the following program extracts the second element of a pair,
using [church encoding]().

```
$ Swambda -e "(λp.(p λx.λy.y) (λx.λy.λp.(p x y) a b))"
(λp.(p λx.λy.y) ((λx.λy.λp.((p x) y) a) b))
(((λx.λy.λp.((p x) y) a) b) λx.λy.y)
((λy.λp.((p a) y) b) λx.λy.y)
(λp.((p a) b) λx.λy.y)
((λx.λy.y a) b)
(λy.y b)
b
```

Note that if for ease of use, one can type `/` rather than `λ`:

```
$ Swambda -e "(/p.(p /x./y.y) (/x./y./p.(p x y) a b))"
...
b
```
