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

Once you have deposited your Markdown and/or Elixir files you can run the mix task `mix make_specs <github_name>` to generate a set of html files.

**N.B.** Do not run the task on ELixir files you do not trust. See [for details](#how-docstrings-are-extracted).

Make sure that `mix test` still passes, if that is not the case, please open an issue for it (in `Earsuite`).

## More Detailed Description

### Spec Extracttion

This is what will be done when you run `mix make_specs <github_name>` and will create _Specs_. In the `specs/Markdown` subtree everything is
really simple. A _Spec_ is a pair of  a Markdown `.md` and an HTML `.html` file.

Inside the `specs/Code/<github_name

1. Depose your _Markdown_ or _Elixir_ files
Either into `specs/Markdown/<github_name>` or  `specs/Code/<github_name>`

1. Run `mix make_specs <github_name>`
This will add a `.html` file for each `.md` file in your `specs/Markdown/<Your Dir>/` and
it will extract all docstrings from your `.ex` files in `specs/Code/<Your Dir>`, but see [How Docstrings Are Extracted](#how-docstrings-are-extracted) below.


Once you have your subdir structure worked out, all you need to do is to add specs.


#### Specs Clobbering

The mix task `make_specs` never clobbers any html files.

You need to erase them manually if you want to create a new
set of tests.

A task to do so shall be provided in the future but something like `find specs/{Code,Markdown}/<github_name> -name "*.html" -exec rm {} \;` shall
do the job, depending on your shell of course and if your tree exists in both `Code` **and** `Markdown`.

Typically we will have a layout like the following

```
    specs
    ├── Code
    │   └── Earmark
    │       ├── earmark
    │       │   ├── alt_parser.ex
    ...
    │       │   └── types.ex
    │       └── earmark.ex
    └── Markdown
        ├── RobertDober
        │   └── kwfuns
        │       ├── README.html
        │       └── README.md
        ├── _deliberate_errors
        │   ├── string_chars_module_doc.html
        │   └── string_chars_module_doc.md
        ├── crertel
        │   ├── headers.html
        │   └── headers.md
        └── elixir-lang
            └── string
                ├── moduledoc.html
                └── moduledoc.md
```

#### Automatic HTML Generation

If you do not have the converted HTML version of your Markdown files you can generate them with the given `Earmark` version in `mix.exs` simply
by running

    mix escript.build
    ./earsuite

##### How Docstrings Are Extracted

When compiling elixir files it is relatively easy to access the docstrings from...

### Earmark Acceptance Test

Change `mix.exs` to point `Earmark` to the local version to acceptance test, e.g. 
    
    {:earmark, path: "/home/robert/git/earmark"},

and simply run the tests


## How it (does/will) work?

Whenever `mix test` is run, the Markdown files will be converted to html and structurally compared to the associated HTML files.

And that is the hard part I am going to work on, especially to make head and tails of the diffs ....


# LICENSE

Same as Elixir, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.
