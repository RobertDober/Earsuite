# Earsuite

An Acceptance and Non Regression Test Suite for [Earmark](https://github.com/pragdave/earmark)  

[![Build Status](https://travis-ci.org/RobertDober/Earsuite.svg?branch=master)](https://travis-ci.org/RobertDober/earsuite)

## Usage

Pull requests are the suggested means to add test cases.

### Adding your own tests

**Attention Draft, might change**

You can only add tests that **pass** in the current version of `Earsuite` implying a certain version for `Earmark` 


Add your specs inside your existing or to be created subdur inside  the `specs` directory. As soon as you are in there
you can use a dir tree almost as wild, strutured or unstructured as you want.

For simplicity and the advantage of avoiding any naming conflicts I will only merge PRs where the name of the specs subdirectory
matches the Github name of the author of the PR.
That is `specs/<spec_type>/<github_name>`  where `<spec_type>` can be `Markdown` or `Code` 

Once you have your subdir structure worked out, all you need to do is to add specs.

A spec is simply a pair of a Markdown `.md` and an HTML `.html` file or a pair of Elixir code `.ex` and HTML `.html`.

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

### Earmark Acceptance Test

Change `mix.exs` to point `Earmark` to the local version to acceptance test, e.g. 
    
    {:earmark, path: "/home/robert/git/earmark"},

and simply run the tests


## How it (does/will) work?

Whenever `mix test` is run, the Markdown files will be converted to html and structurally compared to the associated HTML files.

And that is the hard part I am going to work on, especially to make head and tails of the diffs ....


# LICENSE

Same as Elixir, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.
