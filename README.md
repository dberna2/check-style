# Checkstyle for Java using GitHub Action and Reviewdog

ReviewDog is a developer tool that automates the code review process, it seamlessly integrates with your GitHub Actions workflow and uses Checkstyle for java static code analysis.

# Prerequisites
* A GitHub Actions workflow within your repository. If you don't have it set up yet, check out the official GitHub docs to get started.
* A Checkstyle configuration xml file in your repository. This file defines the coding style rules - you can start with Google's or Sun's check files.

# Action Configuration:

Here is an example of how Checkstyle violations will be displayed in a [pull request](https://github.com/dberna2/java-check-style-example/pull/1).

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

## Configuration options

### github_token

Your GitHub personal access token. It is typically stored as a secret in your GitHub repository.

### checkstyle_config

The checkstyle.xml file path where the team's agreed-upon configurations or coding rules are stored.

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

### use_custom_validations

This is a flag to enable the use of custom validations.

**`Default Value`** : `false`

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
          use_custom_validations: true
          reporter: github-pr-review
          checkstyle_config: google_checks.xml
          level: info
```

> [!IMPORTANT]
> If the `use_custom_validations` field is true the `custom_validations` field is mandatory

### custom_validations

This is the path to the custom validations jar file that defines the set of custom validations to use during the analysis.

**`Default Value`** : `.`

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
          use_custom_validations: true
          custom_validations: custom-validations.jar
          reporter: github-pr-review
          checkstyle_config: google_checks.xml
          level: info
```

### checkstyle_version

Checkstyle version to be used during analysis.

**`Default Value`**: `10.18.2`

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

This is in reference to the distinct patterns for directories or files that should be left out during the CheckStyle scan. It is allowable to set a variety of exceptions.
You have the option to designate specific files, paths, or utilize regular expressions for this purpose.

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
          excluded_paths: ".*Test.*|.*Mock.*"
          level: info
           checkstyle_version: "{{put-your-version}}" # Value as string

```

### workdir

Defines the working directory within the repository for Checkstyle. This is typically the root directory

**`Default Value`**: `.`

### level

Report level for the reviewdog command.

| Level     | GitHub Action Status |
|-----------|----------------------|
| `info`    | neutral              |
| `warning` | neutral              |
| `error`   | failure              |

**`Default Value`**: `info`

### reporter

Reporter for the reviewdog command.
For mor information, you can check the [reviewdog reporter documentation](https://github.com/reviewdog/reviewdog?tab=readme-ov-file#reporters).

**`Values`**: `[github-pr-check, github-check, github-pr-review]`

**`Default Value`**: `github-pr-check`

### filter_mode

This points to the mode for filtering used in the reviewdog command.
For mor information, you can check the [reviewdog filter mode documentation](https://github.com/reviewdog/reviewdog?tab=readme-ov-file#filter-mode).

**`Values`**: `[added, diff_context, file, nofilter]`

**`Default Value`**: `added`

### fail_on_error

This refers to the exit code that reviewdog will return when it encounters errors during its run. For more 
information, you can check the [reviewdog fail on error documentation](https://github.com/reviewdog/reviewdog?tab=readme-ov-file#exit-codes).

**`Values`**: `[true, false]`

**`Default Value:`** `false`
