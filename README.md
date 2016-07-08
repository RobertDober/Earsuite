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

Once you have your subdir structure worked out, all you need to do is to add specs.

A spec is simply a pair of a Markdown `.md` and an HTML `.html` file.

Typically we will have a layout like the following

```
    specs
├── pragdave
│   └── earmark
│       ├── block
│       │   ├── moduledoc.html
│       │   └── moduledoc.md
│       ├── parser
│       │   ├── moduledoc.html
│       │   └── moduledoc.md
│       ├── README.html
│       └── README.md
└── RobertDober
    └── kwfuns
        ├── README.html
        └── README.md

```

Whenever `mix test` is run, the Markdown file will be converted to html and structurally compared to the provided HTML file.

And that is the hard part I am going to work on....


# LICENSE

Same as Elixir, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.
