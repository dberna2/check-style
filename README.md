# Checkstyle for Java using GitHub Action and Reviewdog

This is a GitHub action to run Checkstyle checks on your Java code and report the status via reviewdog on pull requests.

# Example

An example of how the reported Checkstyle violations will look on a pull request is shown below (link to example PR):

# Basic Usage

``` yaml
name: reviewdog

on:
  pull_request:
    types: [ opened, synchronize ]
    
jobs:
  team-agreements-validation:
    name: Validating team agreements
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: dberna2/check-style@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          level: info
```

## Input parameters

### checkstyle_config

Checkstyle configuration specifies which ruleset to apply during the scan.
There are two built-in configurations:

google_checks.xml config for the Google coding conventions
sun_checks.xml config for the Sun coding conventions
It is also possible to supply your custom Checkstyle configuration file located in the same directory.

**`Default Value`** : `google_checks.xml`

### Example

``` yaml
name: reviewdog

on:
  pull_request:
    types: [ opened, synchronize ]
    
jobs:
  team-agreements-validation:
    name: Validating team agreements
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: dberna2/check-style@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          checkstyle_config: google_checks.xml
          level: info
```

### checkstyle_version

Checkstyle version to be used during analysis.

For a list of available version numbers, go to the Checkstyle release page.

**`Default Value`**: `10.14.2`

``` yaml
name: reviewdog

on:
  pull_request:
    types: [ opened, synchronize ]
    
jobs:
  team-agreements-validation:
    name: Validating team agreements
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: dberna2/check-style@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          level: info
           checkstyle_version: "{{put-your-version}}" # Value as string

```

### excluded_paths

En ocaciones queremos que las validaciones no se realicen en ficheros en concreto por diversas razones, para esto, basta 
indicar los ficheros o rutas a excluir.

``` yaml
name: reviewdog

on:
  pull_request:
    types: [ opened, synchronize ]
    
jobs:
  team-agreements-validation:
    name: Validating team agreements
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: dberna2/check-style@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          excluded_paths: "**/SomeFile.java"
          level: info
           checkstyle_version: "{{put-your-version}}" # Value as string

```

### workdir

The working directory relative to the root directory.

**`Default Value`**: `.`

# `level`

Report level for the reviewdog command.

| Level     | GitHub Action Status |
|-----------|----------------------|
| `info`    | neutral              |
| `warning` | neutral              |
| `error`   | failure              |

**`Default Value`**: `info`

### reporter

Reporter for the reviewdog command.

**`Values`**: `[github-pr-check, github-check, github-pr-review]`

**`Default Value`**: `github-pr-check`

### filter_mode

Filtering mode for the reviewdog command.

**`Values`**: `[added, diff_context, file, nofilter]`

**`Default Value`**: `added`

### fail_on_error

Exit code for reviewdog when errors are found.

**`Values`**: `[true, false]`

**`Default Value:`** `false`
