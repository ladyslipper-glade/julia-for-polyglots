### A Pluto.jl notebook ###
# v0.20.27

using Markdown
using InteractiveUtils

# ╔═╡ 4212fffd-f54c-4f43-a180-1410147cfcf3
md"""
# Getting Started with Julia

Welcome to *Julia for Polyglots*. This first notebook is a guided tour. If you
already know two or three programming languages, you should finish it with a
clear answer to four questions:

1. **What is Julia, and where did it come from?**
2. **What kinds of problems is Julia genuinely good at?**
3. **How do I install it and run my first program?**
4. **What does the language actually feel like to use?**

There is no homework here. The deeper material — types, dispatch, functions,
collections, performance — starts in the notebooks that follow. For now, read,
poke at the code cells, and change a number or two to see what happens.
"""

# ╔═╡ c7ae1899-7d6e-440e-96fd-13eb86e63aaa
md"""
## 1. A Brief History

Julia began at MIT in 2009 as a research project by **Jeff Bezanson**,
**Stefan Karpinski**, **Viral B. Shah**, and **Alan Edelman**. The team was
frustrated by a pattern that anyone who has done serious numerical work will
recognise — the **two-language problem**.

The pattern goes like this. You prototype an idea in a high-level language
like Python, R, or MATLAB because it is pleasant and interactive. When the
prototype is too slow, you rewrite the hot loops in C, C++, or Fortran and
call them from the original language through a foreign-function interface.
Now you maintain two codebases, two build systems, and two mental models, and
your scientists have to either become C programmers or hand their work off to
someone who is.

The Julia team set out to design a single language that could be both the
prototyping language and the production language. In their 2012 announcement,
*[Why We Created Julia](https://julialang.org/blog/2012/02/why-we-created-julia/)*,
they put it this way:

> *We want a language that's open source, with a liberal license. We want the
> speed of C with the dynamism of Ruby. We want a language that's homoiconic,
> with true macros like Lisp, but with obvious, familiar mathematical notation
> like Matlab. We want something as usable for general programming as Python,
> as easy for statistics as R, as natural for string processing as Perl, as
> powerful for linear algebra as Matlab, as good at gluing programs together
> as the shell. Something that is dirt simple to learn, yet keeps the most
> serious hackers happy.*

The first public release was in **February 2012**. Julia **1.0** — the point
at which the language committed to a stable syntax and a backwards-compatible
1.x series — shipped at JuliaCon in **August 2018**. Since then the release
cadence has been steady: 1.6 (the first LTS), 1.10 (the current long-term
support release), and 1.12 as the current stable release at the time this
tutorial was written.

Julia is **MIT-licensed** open source. The reference implementation and most
of the standard library live at
[github.com/JuliaLang/julia](https://github.com/JuliaLang/julia), and a large
volunteer community maintains thousands of registered packages.
"""

# ╔═╡ 9314323b-2a54-40be-9473-e9f67d460d87
md"""
## 2. What is Julia Good At?

The shortest honest answer: **anywhere you would normally reach for NumPy,
MATLAB, R, or Fortran, and any place where you have ever caught yourself
saying "I wish I didn't have to rewrite this in C."**

A few areas where Julia has a strong presence:

- **Scientific and numerical computing.** Linear algebra, ODEs and PDEs,
  optimisation, statistics. The
  [SciML](https://sciml.ai/) ecosystem in particular has world-class
  differential equation solvers.
- **Data science and statistics.** `DataFrames.jl` plays a similar role to
  pandas or R's `data.frame`, with the advantage that the data structures
  are written in Julia itself and stay fast under user-defined functions.
- **Machine learning and differentiable programming.**
  [`Flux.jl`](https://fluxml.ai/) and
  [`Lux.jl`](https://lux.csail.mit.edu/) provide neural networks written
  natively in Julia, and `Zygote.jl` and `Enzyme.jl` provide automatic
  differentiation that works on essentially arbitrary Julia code.
- **High-performance computing.** Julia code routinely runs on supercomputers,
  with first-class support for threads, distributed clusters, MPI, and GPUs
  (`CUDA.jl`, `AMDGPU.jl`, `Metal.jl`, `oneAPI.jl`).
- **Quantitative finance, economics, and operations research.** Julia is
  popular at central banks, hedge funds, and energy-system modellers, partly
  because of `JuMP.jl`, a domain-specific language for mathematical
  optimisation that is widely considered best-in-class.
- **Symbolic and computer-algebra work.** `Symbolics.jl` and `ModelingToolkit.jl`
  give you Mathematica-style symbolic manipulation that composes with the
  rest of the numerical ecosystem.

Where Julia is **less** of an obvious win: small one-off shell scripts (the
startup-and-compile cost shows), mobile apps, front-end web development, and
deeply embedded systems. The new `juliac` ahead-of-time compiler introduced
alongside Julia 1.12 is starting to chip away at the first of those — small
standalone binaries are now possible — but Python or Go are still better
choices for "I just need a 30-line CLI tool" work.
"""

# ╔═╡ cc32b51d-84ef-4889-8fd0-1205bf29080c
md"""
## 3. Three Ideas That Make Julia *Julia*

Before you write any code, it is worth knowing what makes Julia different
from the other dynamic languages you already know. There are three ideas
that you will see again and again throughout this tutorial.

### 3.1 Just-In-Time compilation via LLVM

Julia is a dynamic language — there is a REPL, you can redefine functions
on the fly, values carry their types at runtime — but it is **not**
interpreted. Every function is compiled to native machine code by
[LLVM](https://llvm.org/) the first time it is called with a particular
combination of argument types. The result is performance that is routinely
within a factor of 1–2× of hand-written C or Fortran on numerical code,
without you having to leave the language.

The cost is **latency**: the first call to a function pays a compilation
tax. This is the famous "time-to-first-plot" problem that long haunted
Julia. The story has improved dramatically in recent versions thanks to
native code caching in package precompilation, but you will still notice
that the *first* `plot(...)` in a session is slow and every subsequent one
is instant.

### 3.2 A rich type system without static typing

Julia has an elaborate, hierarchical type system with abstract types,
concrete types, and parametric types. But — crucially — **you almost never
have to write the types down**. Type annotations are optional and are used
primarily for *dispatch* (choosing which method to run), not for compile-time
checking. Code without annotations is just as fast as code with them,
because the compiler infers the types itself.

### 3.3 Multiple dispatch as the central organising principle

Most languages let you choose a method based on the type of one receiver:
in `x.foo(y)`, the type of `x` decides which `foo` runs. Julia chooses
based on the types of **all** the arguments. A function like `+` has
hundreds of methods — one for `(Int, Int)`, one for `(Float64, Float64)`,
one for `(Matrix, Matrix)`, one for `(SparseMatrix, Vector)`, and so on —
and the right one is selected at every call.

This sounds like a small thing. In practice it is the feature that lets
unrelated packages compose: a new number type from one package works with
a differential equation solver from another package and a plotting library
from a third, with no glue code, because every operation is just a generic
function with the right methods.

Notebook 03 is devoted entirely to dispatch. For now, just keep the phrase
in your back pocket — when something surprising or pleasant happens in
Julia, multiple dispatch is usually why.
"""

# ╔═╡ 8e4e5e5b-4779-4978-9c71-fb20bc6fd8be
md"""
## 4. Getting Set Up

The full setup instructions live in this repository's
[README](../README.md). The very short version is:

1. **Install Julia.** Use the official installer from
   <https://julialang.org/downloads/>, or the `juliaup` version manager
   (recommended — it makes upgrading and switching versions painless).
   Verify with `julia --version` in a terminal.
2. **Clone this repository** and `cd` into it.
3. **Start Julia with the project activated:** `julia --project=.`
4. **Instantiate the environment** — at the `julia>` prompt, press `]` to
   enter package mode, then type `instantiate` and wait. This downloads
   and precompiles every package listed in `Project.toml`. It takes a few
   minutes the first time and is essentially instant on subsequent runs.
5. **Launch Pluto:** press *Backspace* to leave package mode, then
   `import Pluto; Pluto.run()`. A browser tab will open. Point it at
   `notebooks/01-getting-started.jl` and you are looking at this file.

If you are reading this *inside* a running Pluto session, congratulations —
step 5 already worked.
"""

# ╔═╡ d908f1c6-5c83-4e74-9bc2-82a4728d2301
md"""
### A note on Pluto's reactivity

Pluto notebooks are **reactive**, like a spreadsheet. When you change a
cell, every other cell that depends on it re-runs automatically. This has
two practical consequences you should know about up front:

- **Each global name may be defined in only one cell.** If you write
  `x = 1` in two different cells, Pluto will flag both as errors. Use
  `let ... end` blocks (which introduce local scope) when you want to
  reuse a name for scratch work.
- **The order of cells in the file does not determine the order of
  execution.** Dependencies do. Feel free to put helper definitions below
  the cells that use them if it reads better.

You will see `let ... end` used heavily in the examples below for exactly
this reason.
"""

# ╔═╡ 04df1f8f-9d54-43e6-9a82-aa7338af5824
md"""
## 5. A First Look at Julia

The rest of this notebook is a sampler — short snippets meant to give you a
*feel* for the language. Don't worry about memorising syntax; later
notebooks cover every topic systematically. Just read, run the cells, and
notice what looks familiar and what looks different.

### 5.1 Arithmetic and variables

The basics look the way you would hope. Julia is dynamically typed but
every value has a concrete type that you can inspect.
"""

# ╔═╡ 5d526685-df48-4f97-9e29-0a870c59e4e3
x = 42

# ╔═╡ 31fd0159-0dae-455d-bf1b-f33b432c54de
typeof(x)

# ╔═╡ ac43b1b9-8a95-480e-bf29-9905b67d059a
y = 3.14

# ╔═╡ ed862e5d-5ee0-4d90-b5ee-1672d16cc4eb
typeof(y)

# ╔═╡ ed2c8001-bf8d-435f-a4d5-069c84a6b08f
md"""
On a 64-bit machine, integer literals default to `Int64` and floating-point
literals to `Float64`. Notice that you did not have to declare anything —
the type comes from the literal.

Julia is happy with **Unicode** identifiers and operators. The following is
not a parlour trick; it is idiomatic.
"""

# ╔═╡ 3a52c8e8-27b8-44bb-9ce9-fa5f96aed4a9
α = 0.1

# ╔═╡ b7625b1d-35c2-466c-a4c8-369f39c2b57b
β = 0.2

# ╔═╡ b639e60f-3cc4-42ae-b7dd-e43f1872d0f3
α + β ≈ 0.3      # \approx<TAB> in the REPL or Pluto editor

# ╔═╡ ef0d3ada-1ead-47d1-b972-55a0b42de34f
md"""
That last cell quietly demonstrates two more things worth pointing out.
`≈` is Julia's *approximate equality* operator — useful because, as in
every language with IEEE-754 floats, `0.1 + 0.2 == 0.3` is `false`.
And `α`, `β`, and `≈` were all typed by entering a LaTeX command
(`\alpha`, `\beta`, `\approx`) followed by *Tab*.
"""

# ╔═╡ d6f0a7d8-2fab-4032-9e98-f2a406b027df
md"""
### 5.2 Functions

There are two ways to write a function. The long form looks like most
other languages:
"""

# ╔═╡ 69877342-a0cd-4522-9346-34ae3a737147
function greet(name)
    return "Hello, $(name)!"
end

# ╔═╡ 763175ff-fb33-4066-97f3-eb1f3b905ed3
greet("Julia")

# ╔═╡ 6ec74335-2c56-4d37-9457-6d309b71312b
md"""
The `return` keyword is optional — a Julia function returns the value of
its last expression — but writing it explicitly is fine and is often
clearer. The `$(...)` inside the string is **string interpolation**, the
same idea you may know from Ruby, Kotlin, or Swift.

For one-liners there is a compact form that looks just like the
mathematical definition:
"""

# ╔═╡ 560092f9-341d-4f10-afdc-b0c25acba065
square(n) = n * n

# ╔═╡ 18127994-55a2-41e5-99d5-a462286a0ab4
square(9)

# ╔═╡ a73c578c-e3d8-4bbe-88d1-1203ace878e1
md"""
Notice that `square` works on any type that supports `*`. We did not write
any type annotations, and we did not have to — the function is
**generic**. Pass it an integer and you get an integer back; pass it a
float and you get a float; pass it a matrix and you get a matrix:
"""

# ╔═╡ 23cd8c82-ba3a-4cd3-a2d0-ddd30de54343
square(2.5)

# ╔═╡ 2c981579-b14d-478f-b1d9-191c258aa295
square([1 2; 3 4])     # 2×2 matrix literal — yes, that is matrix multiplication

# ╔═╡ 64e25f86-55dd-46c9-a2bc-e5853f7ecae1
md"""
### 5.3 Arrays, ranges, and broadcasting

Arrays are built into the language with MATLAB-style syntax. Indexing is
**1-based** and uses square brackets (you will get used to it):
"""

# ╔═╡ c2f26c70-ff1b-4744-9114-044d2309ca90
v = [10, 20, 30, 40, 50]

# ╔═╡ 892795c8-dc9e-497f-858e-163833efac62
v[1], v[end]

# ╔═╡ 5b3b4ccc-4955-45fd-ac18-ec47f50e79a0
md"""
Ranges are first-class lazy objects. `1:10` is not an array; it is a
`UnitRange` that knows how to iterate.
"""

# ╔═╡ 131e54c6-817f-4958-8f03-e5e5bb8c5ddf
sum(1:1_000_000)      # underscores are allowed in numeric literals

# ╔═╡ c7a3cb0d-d4a7-48e8-a767-51e6d6b9b666
md"""
The killer feature for numerical work is **broadcasting**. Putting a `.`
in front of (almost) any function or operator applies it elementwise. There
is no need for special `np.vectorize`-style wrappers — every function is
already broadcastable.
"""

# ╔═╡ ec14322d-394e-43a8-8f5c-90ef1c2a6fb0
sin.(0:0.5:2π)        # sine of every element from 0 to 2π in steps of 0.5

# ╔═╡ e6d16304-5419-4fa0-a204-f2231185bca6
let
    a = [1, 2, 3]
    b = [10, 20, 30]
    a .+ b .* 2       # elementwise: [1+20, 2+40, 3+60]
end

# ╔═╡ 14e7b62e-f9f7-43fe-ae11-d40c8ebb605e
md"""
You can also use **comprehensions**, which read very much like Python's:
"""

# ╔═╡ 6c09b2ca-a9b8-4cdb-8a64-89c9a2974912
[n^2 for n in 1:10 if iseven(n)]

# ╔═╡ 26351804-5367-4afd-9c35-685c7e91070b
md"""
### 5.4 A motivating example: prime sieve

A short, complete example that puts a few pieces together. The Sieve of
Eratosthenes finds all primes up to `n`. Read it as you would read
pseudocode — the syntax should be self-explanatory.
"""

# ╔═╡ 36057536-05d4-46af-8ac5-6f641df3adf7
function primes_up_to(n::Integer)
    is_prime = trues(n)         # a BitVector of length n, all true
    is_prime[1] = false         # 1 is not prime
    for i in 2:isqrt(n)
        if is_prime[i]
            for j in (i*i):i:n   # step by i, starting at i²
                is_prime[j] = false
            end
        end
    end
    return findall(is_prime)    # indices of remaining `true` entries
end

# ╔═╡ 1a407a31-f5d8-42f0-a90c-9b6eb2d790c1
primes_up_to(50)

# ╔═╡ 34713d00-021c-41c7-85d9-321561f401ab
md"""
Things worth pointing out in those nine lines:

- **`n::Integer`** is a type annotation used for dispatch. Anything that is
  an `Integer` — `Int64`, `Int32`, `BigInt`, `UInt8`, ... — is accepted.
  Pass a `Float64` and you will get a *no method matching* error rather
  than a silent truncation.
- **`trues(n)`** allocates a packed bit-vector — one bit per element, not
  one byte — and is the kind of small, sharp tool the standard library is
  full of.
- **`for j in (i*i):i:n`** uses a stepped range: start at `i²`, step by
  `i`, stop at `n`. The `start:step:stop` syntax should look familiar from
  MATLAB.
- **`findall`** is the kind of higher-order helper you reach for instead
  of writing an index-tracking loop by hand.

Try editing the argument — `primes_up_to(200)`, `primes_up_to(10_000)` —
and watch Pluto re-run automatically.
"""

# ╔═╡ 3898e812-6039-4467-a752-c34f107d47a5
md"""
### 5.5 One more taste: linear algebra is first-class

Numerical linear algebra is built into the standard library. Solving a
linear system `Ax = b` is a single character — the backslash operator:
"""

# ╔═╡ 9c26b554-86e7-4714-b58d-1a9af32c5196
let
    A = [1.0  2.0  3.0;
         4.0  1.0  6.0;
         7.0  8.0  1.0]
    b = [ 6.0, 11.0, 16.0]
    A \ b              # solves A * x = b; equivalent to inv(A) * b but faster and more stable
end

# ╔═╡ 3b4aa1e1-9177-40bf-a35c-25e4396c6727
md"""
Behind that single `\` is a dispatch to a method that inspects `A`,
notices it is a generic dense `Matrix{Float64}`, and calls into LAPACK's
LU solver. If `A` had been a `SymTridiagonal`, a sparse matrix, or a
`Diagonal`, dispatch would have selected a different — and much faster —
algorithm with no change to the calling code. This is multiple dispatch
quietly earning its keep.
"""

# ╔═╡ c2a8f3d4-1234-4abc-9def-fedcba987654
md"""
## 6. Where to Next

That is the tour. You have seen the language's history, its strengths,
how to install it, and enough syntax to read most short snippets you will
encounter in the wild. The notebooks that follow take everything you just
saw and explain it properly:

| Notebook | Topic |
|---|---|
| 02 | **Control flow** — conditionals, loops, comprehensions, and how Julia handles short-circuiting |
| 03 | **Types and multiple dispatch** — the heart of the language |
| 04 | **Functions and closures** — anonymous functions, higher-order functions, `do`-blocks |
| 05 | **Collections** — arrays, tuples, named tuples, dictionaries, sets |
| 06 | **Modules and packages** — the package manager and `Project.toml` files |
| 07 | **Metaprogramming** — expressions, macros, and code that writes code |
| 08 | **Performance and benchmarking** — `@code_warntype`, `BenchmarkTools.jl`, and how to think about allocations |
| 09 | **DataFrames** — Julia's answer to pandas / `data.frame` |
| 10 | **Plotting and visualisation** — `Plots.jl` and friends |

### Tips for the rest of the tutorial

- **Run every code cell.** Modify the numbers. Break things. Pluto's
  reactivity makes it cheap to experiment.
- **Use the help mode in the REPL.** Press `?` at the `julia>` prompt and
  then type any name — for example `?findall` — to read the full
  docstring. Inside Pluto, the *Live docs* panel in the lower-right corner
  does the same thing for whatever your cursor is on.
- **Bookmark the official manual.** The reference at
  <https://docs.julialang.org/> is excellent and worth dipping into early
  and often.
- **Don't worry about performance yet.** Write idiomatic, readable code
  first. Notebook 08 will teach you how to measure and tune; until then,
  the compiler is on your side.

When you are ready, open
[`02-control-flow.jl`](./02-control-flow.jl) and keep going. Welcome to Julia.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.6"
manifest_format = "2.0"
project_hash = "71853c6197a6a7f222db0f1978c7cb232b87c5ee"

[deps]
"""

# ╔═╡ Cell order:
# ╠═4212fffd-f54c-4f43-a180-1410147cfcf3
# ╟─c7ae1899-7d6e-440e-96fd-13eb86e63aaa
# ╟─9314323b-2a54-40be-9473-e9f67d460d87
# ╟─cc32b51d-84ef-4889-8fd0-1205bf29080c
# ╟─8e4e5e5b-4779-4978-9c71-fb20bc6fd8be
# ╟─d908f1c6-5c83-4e74-9bc2-82a4728d2301
# ╟─04df1f8f-9d54-43e6-9a82-aa7338af5824
# ╠═5d526685-df48-4f97-9e29-0a870c59e4e3
# ╠═31fd0159-0dae-455d-bf1b-f33b432c54de
# ╠═ac43b1b9-8a95-480e-bf29-9905b67d059a
# ╠═ed862e5d-5ee0-4d90-b5ee-1672d16cc4eb
# ╟─ed2c8001-bf8d-435f-a4d5-069c84a6b08f
# ╠═3a52c8e8-27b8-44bb-9ce9-fa5f96aed4a9
# ╠═b7625b1d-35c2-466c-a4c8-369f39c2b57b
# ╠═b639e60f-3cc4-42ae-b7dd-e43f1872d0f3
# ╟─ef0d3ada-1ead-47d1-b972-55a0b42de34f
# ╟─d6f0a7d8-2fab-4032-9e98-f2a406b027df
# ╠═69877342-a0cd-4522-9346-34ae3a737147
# ╠═763175ff-fb33-4066-97f3-eb1f3b905ed3
# ╟─6ec74335-2c56-4d37-9457-6d309b71312b
# ╠═560092f9-341d-4f10-afdc-b0c25acba065
# ╠═18127994-55a2-41e5-99d5-a462286a0ab4
# ╟─a73c578c-e3d8-4bbe-88d1-1203ace878e1
# ╠═23cd8c82-ba3a-4cd3-a2d0-ddd30de54343
# ╠═2c981579-b14d-478f-b1d9-191c258aa295
# ╟─64e25f86-55dd-46c9-a2bc-e5853f7ecae1
# ╠═c2f26c70-ff1b-4744-9114-044d2309ca90
# ╠═892795c8-dc9e-497f-858e-163833efac62
# ╟─5b3b4ccc-4955-45fd-ac18-ec47f50e79a0
# ╠═131e54c6-817f-4958-8f03-e5e5bb8c5ddf
# ╟─c7a3cb0d-d4a7-48e8-a767-51e6d6b9b666
# ╠═ec14322d-394e-43a8-8f5c-90ef1c2a6fb0
# ╠═e6d16304-5419-4fa0-a204-f2231185bca6
# ╟─14e7b62e-f9f7-43fe-ae11-d40c8ebb605e
# ╠═6c09b2ca-a9b8-4cdb-8a64-89c9a2974912
# ╟─26351804-5367-4afd-9c35-685c7e91070b
# ╠═36057536-05d4-46af-8ac5-6f641df3adf7
# ╠═1a407a31-f5d8-42f0-a90c-9b6eb2d790c1
# ╟─34713d00-021c-41c7-85d9-321561f401ab
# ╟─3898e812-6039-4467-a752-c34f107d47a5
# ╠═9c26b554-86e7-4714-b58d-1a9af32c5196
# ╟─3b4aa1e1-9177-40bf-a35c-25e4396c6727
# ╟─c2a8f3d4-1234-4abc-9def-fedcba987654
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
