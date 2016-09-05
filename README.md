# Earsuite

An Acceptance and Non Regression Test Suite for [Earmark](https://github.com/pragdave/earmark)  

[![Build Status](https://travis-ci.org/RobertDober/Earsuite.svg?branch=master)](https://travis-ci.org/RobertDober/earsuite)

## Still Work In Progress

the below described workflow is not yet implemented...

## Quick Starting Guide

Pull requests are the suggested means to add test cases.

Here is how to do it.

You can only add tests that **pass** in the current version of `Earsuite` implying a certain version for `Earmark`.

Add your specs inside your existing or to be created subdir inside  the `specs` directory. As soon as you are in there
you can use a dir tree almost as wild, strutured or unstructured as you want.

For simplicity and the advantage of avoiding any naming conflicts we will only merge PRs where the name of the specs subdirectory
matches the Github name of the author of the PR.

That is `specs/<spec_type>/<github_name>`  where `<spec_type>` can be `Markdown` or `Code` 

Once you have deposited your Markdown and/or Elixir files you can run the mix task

     mix make_specs <github_name>

 to generate a set of html files.

Make sure that `mix test` still passes, if that is not the case, please open an issue for it (in `Earsuite`).

## More Detailed Description

### Spec Extraction

This is what will be done when you run `mix make_specs <github_name>` and will create _Specs_. In the `specs/<github_name>/Markdown` subtree everything is
really simple. A _Spec_ is a pair of  a Markdown `.md` and an HTML `.html` file. And if the html does not exist it will be created by means of the current
version of `Earmark`.

Inside the `specs/<github_name>/Code` directory things are slightly more complicated, we have a tripple of an Elixir `.exs?`, Markdown and HTML file. Again, if the
Markdown **and** the HTML file do not exist they will be created in two steps.

1. Extraction of the Markdown from the Elixir File
The Elixir File is parsed into its AST representation via `Code.string_to_ast` and then `@moduledoc` and `@doc` strings are extracted into a Markdown file which then is treated in the second step.
If interested in the details of this process, see [How Docstrings Are Extracted](#how-docstrings-are-extracted) below.

1. The Markdown file is converted to an HTML file with the current version of `Earmark`, exactly like inside the `Markdown` subdirectory.


Once you have your subdir structure worked out, all you need to do is to add specs.


##### How Docstrings Are Extracted

When compiling elixir files it is relatively easy to access the docstrings from the resulting objects, however it is not safe. Imagine the following code

```elixir

defmodule Inject do
  invocation_of_unsecure_function
end
```

Therefore docstrings are extracted from the AST which is created by means of invocation of `Code.quoted_to_string`, which only tokenizes the Elixir files
without compiling them.

This, however, imposes an important restriction. Docstrings containing interpolations as, e.g.

```elixir
    @moduledoc "#{danger(:Will, :Robinson)}"
```

will not be extracted.

### Earmark Acceptance Test

Change `mix.exs` to point `Earmark` to the local version to acceptance test, e.g. 
    
    {:earmark, path: "/home/robert/git/earmark"},

and simply run the tests


## How it (does/will) work?

Whenever `mix test` is run, the Markdown files will be converted to html and structurally compared to the associated HTML files.

And that is the hard part I am going to work on, especially to make head and tails of the diffs ....


# LICENSE

Same as Elixir, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.
