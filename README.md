
> [!NOTE]
> A message from the human...
>
> There are four ways AI can be used to prepare text:
>
> 1. The AI can generate the entire document with no human intervention or review.
> 2. The AI can generate an initial draft of the document that is then checked and edited by a human.
> 3. The human can generate an initial draft of the document that is then checked and edited by AI.
> 4. The human can generate the entire document without any AI assistance.
>
> All of these approaches have merit. This tutorial was written using the second approach mentioned
> above. I used Perplexity Computer to compute the initial draft of each section of this tutorial,
> but then I reviewed that draft, verified that it was correct and that the samples worked, and
> edited it further as needed. I moved through the tutorial one section at a time, generating and
> cleaning up each section before moving on to the next.
>
> My purpose in taking this approach was, in part, to gain more experience with AI-assisted writing
> and editing, as well as to produce a useful Julia tutorial. I should note that when I started this
> project I did not know Julia myself. Writing this (or more precisely, editing the AI-generated
> output) was an opportunity for me to learn the language. In that respect, it was an experiment in
> AI-assisted learning as well.
>
> One concern about using an AI tool to generate non-trivial amounts of text is the possibility that
> copyrighted material from the training data will leak into the generated output. It is unfortunate
> that I need to worry about this, but I do. If you find any text that has obviously been lifted
> from elsewhere with proper attribution, please let me know, and I will remove or rework those
> sections.
>
> Anne

# Julia for Polyglots

This repository contains a hands-on Julia tutorial aimed at learners who already know two or more
programming languages. Rather than starting from first principles, this tutorial leans on what you
already understand from other languages about types, functions, collections, and performance, and
explains how Julia's design choices differ from what you are used to.

The tutorial is delivered as a series of [Pluto](https://plutojl.org/) reactive notebooks so you can
run, edit, and experiment with every example as you read.

---

## Notebooks

| # | Topic |
|---|-------|
| 01 | Getting Started with Julia |
| 02 | Types and Multiple Dispatch |
| 03 | Functions and Closures |
| 04 | Collections: Arrays, Tuples, Dicts, and Sets |
| 05 | Control Flow and Comprehensions |
| 06 | Modules and the Package Ecosystem |
| 07 | Metaprogramming: Macros and Expressions |
| 08 | Performance and Benchmarking |
| 09 | Working with Data and DataFrames |
| 10 | Plotting and Visualization |

---

## Prerequisites

- Julia 1.10 or later
- Git (to clone this repository)
- Any modern web browser
- (Optional) Any programming editor such as [Visual Studio Code](https://code.visualstudio.com/)
  or [Zed](https://zed.dev/)

---

## Setup

### Install Julia

Download the current stable release from <https://julialang.org/downloads/>. Use the **official
installer** for your platform; it places the `julia` executable on your `PATH` automatically.

Verify the installation:

```
julia --version
```

### Clone This Repository

```bash
git clone https://github.com/ladyslipper-glade/julia-for-polyglots.git
cd julia-for-polyglots
```

### Install Project Dependencies

Launch Julia from the repository root. Note that in the following command the `.` names the current
directory as the project root:

```bash
julia --project=.
```

Inside the Julia REPL, activate the package manager and instantiate the project environment:

```julia
julia> ]          # press ] to enter Pkg mode — the prompt changes to (julia-for-polyglots) pkg>
pkg> instantiate  # downloads and precompiles all declared dependencies
pkg>              # press Backspace to return to the Julia REPL
```

The `instantiate` command may take several minutes to run, depending on your machine, internet
connection, and the number of dependencies.

You only need to run `instantiate` once (or again after pulling updates that change `Project.toml`).

### Launch Pluto

Pluto is listed as a dependency, so it was installed in the previous step. Start it from the Julia
REPL:

```julia
julia> import Pluto; Pluto.run()
```

Pluto will print a local URL (e.g. `http://localhost:1234/`) and attempt to open it in your default
browser. If it does not open automatically, paste the URL into any browser.

### Open a Notebook

This tutorial is organized as a collection of Pluto notebooks in the `notebooks/` directory. Once
Pluto is running, you can open any `.jl` file from this directory in Pluto's browser interface to
view or edit the notebook. There is no need to use a text editor to view the tutorial. Start with
the file `01-getting-started.jl`.

If you are familiar with Python Jupyter notebooks, you can think of Pluto notebooks as a modern,
browser-based alternative. However, Julia supports Jupyter notebooks as well, and you may find it
interesting to experiment with both as you gain experience. Further instructions are contained in
the tutorial itself.

### Configure an Editor (Optional)

When writing Julia applications, you will may wish to use an ordinary text editor to develope your
code rather than using a notebook editor. Here we discribe how to set up [Visual Studio
Code](https://code.visualstudio.com/) and [Zed](https://zed.dev/) for Julia development.

#### Visual Studio Code

1. Install Visual Studio Code and open it on the project directory.
2. Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (macOS) to open the Extensions panel.
3. Search for **Julia** and install the extension published by *julialang* (identifier:
   `julialang.language-julia`).
4. Restart Visual Studio Code if prompted.

The extension bundles a language server, and an integrated REPL. Note that, unlike for Jupyter
notebooks, the Julia extension does not support Pluto notebooks.

> **Tip:** Keep the Julia REPL panel open in VS Code (`View → Terminal`, then
> launch Julia with `julia --project=.`). The extension uses that REPL
> session, so your project environment is already active.

#### Zed

1. Install Zed and open it on the project directory.
2. Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (macOS) to open the Extensions tab.
3. Search for **Julia** and install the extension published by *Paul Berg*.
4. Restart Zed if prompted.

---

## Project Structure

```
julia-for-polyglots/
├── Project.toml          # Package environment declaration
├── Manifest.toml         # (generated) Exact dependency lock file
├── notebooks/
│   ├── 01-getting-started.jl
│   ├── 02-types-and-dispatch.jl
│   ├── 03-functions-and-closures.jl
│   ├── 04-collections.jl
│   ├── 05-control-flow.jl
│   ├── 06-modules-and-packages.jl
│   ├── 07-metaprogramming.jl
│   ├── 08-performance.jl
│   ├── 09-data-and-dataframes.jl
│   └── 10-plotting-and-visualization.jl
└── README.md
```

---

## License

See [LICENSE](LICENSE).
