# Linting

## Resources

### Linters:

`SwiftLint`: https://github.com/realm/SwiftLint
<br>
`SwiftLint Rules`: https://realm.github.io/SwiftLint/rule-directory.html


`SwiftFormat`: https://github.com/nicklockwood/SwiftFormat
<br>
`SwiftFormat Rules`: https://github.com/nicklockwood/SwiftFormat/blob/master/Rules.md

### Style guide:

`Airbnb`: https://github.com/airbnb/swift
> Linting rule choices mostly adhere to this style guide

---

## Installation

`SwiftLint`: Prebuilt, no steps needed
<br>
`SwiftFormat`: Prebuilt, no steps needed

---

## Usage

Use this script in the project build phase:
> ```bash
> #!/bin/bash
> 
> projectFolder=$SRCROOT
> cd $projectFolder
> 
> repoRoot=$(git rev-parse --show-toplevel)
> lintingFolder="$repoRoot/Linting"
> lintingScript="$lintingFolder/lint.sh"
> 
> if test -f $lintingScript; then
>     $lintingScript
> else 
>     echo "warning: missing linting script"
> fi
> ```

---

## Output

When linting locally, warnings will appear in Xcode, as well as written to json files in the `Linting/Reports` folder (ignored by git):
- `mmuf-app-ios/Linting/Reports/swiftlint-report.json` (swiftlint pass on project folder)
- `mmuf-app-ios/Linting/Reports/swiftformat-report.json` (swiftformat pass on project folder)

---

## Disabling rules

Ideally, all rules should be respected.

But if a rule cannot be enforced due to a bug in one of the linters, conflicting rules, etc... please consider disabling the problematic rule in the config instead of locally in code.

If absolutely necessary, this is how to handle disabling siwftlint rules in code:

### `SwiftLint`:

Available disablers:
> ```swift
> // swiftlint:disable:next <rule_name> # disables rule in the next line
> // swiftlint:disable:this <rule_name> # disables rule in the current line
> // swiftlint:disable:previous <rule_name> # disables rule in the previous line
> // swiftlint:disable <rule_name> # disables rule starting from the line where this is declared
> // swiftlint:enable <rule_name> # enables rule starting from the line where this is declared
> // swiftlint:disable all # disables all rules starting from the line where this is declared
> // swiftlint:enable all # enables all rules starting from the line where this is declared
> ```

- *note*: A `SwiftLint` rule will always have the rule name at the *end* of the warning message, ex:
> `Force Unwrapping Violation: Force unwrapping should be avoided. (force_unwrapping)`

Here are the docs on how to disable swiftlint rules: https://github.com/realm/SwiftLint#disable-rules-in-code

### `SwiftFormat`:

Available disablers:
> ```swift
> // swiftformat:disable:next <rule_name> # disables rule in the next line
> // swiftformat:disable <rule_name> # disables rule starting from the line where this is declared
> // swiftformat:enable <rule_name> # enables rule starting from the line where this is declared
> // swiftformat:disable all # disables all rules starting from the line where this is declared
> // swiftformat:enable all # enables all rules starting from the line where this is declared
> ```

- *note*: A `SwiftFormat` rule will always have the rule name at the *beginning* of the warning message, ex:
> `(consecutiveBlankLines) Replace consecutive blank lines with a single blank line.`

Here are the docs on how to disable swiftformat rules: https://github.com/nicklockwood/SwiftFormat#rules

---

## Updating to new linter versions in the repo

### `SwiftLint`:

1. Download `SwiftLint.pkg` for the desired version.
> You can find `SwiftLint.pkg` for a specific version at `https://github.com/realm/SwiftLint/releases/tag/x.x.x` (ex: https://github.com/realm/SwiftLint/releases/tag/0.47.1)

2. Run the `SwiftLint.pkg` installer, and replace the executable at `mmuf-app-ios/Linting/swiftlint`:
> ```bash
> cp -f /usr/local/bin/swiftlint mmuf-app-ios/Linting/swiftlint
> ```
> - *note*: `mmuf-app-ios/Linting/swiftlint` should be the *full* path to the `swiftlint` executable in your repo folder

*note*: If you use a different method to get the `swiftlint` executable than described above, must make sure the executable has both `arm64` and `x86_64` support

3. Edit `mmuf-app-ios/Linting/swiftlint.version` with the updated version.

### `SwiftFormat`:

1. Download `Source Code (zip)` for the desired version.
> You can find `Source Code (zip)` for a specific version at `https://github.com/nicklockwood/SwiftFormat/releases/tag/x.x.x` (ex: https://github.com/nicklockwood/SwiftFormat/releases/tag/0.49.8)
> - *note*: don't just clone the repo off of `master` and try to build off of that as it's unstable...

2. Unzip `Source Code (zip)`, and `cd` into the folder:
> ```bash
> cd SwiftFormat-0.49.8
> ```

3. Build the project for both `arm64` and `x86_64`:
> ```bash
> swift build -c release --arch arm64 --arch x86_64
> ```

4. Replace the executable at `mmuf-app-ios/Linting/swiftformat`:
> ```bash
> cp -f .build/apple/Products/Release/swiftformat mmuf-app-ios/Linting/swiftformat
> ```
> - *note*: `mmuf-app-ios/Linting/swiftlint` should be the full path to the `swiftlint` executable in your repo folder

*note*: If you use a different method to get the `swiftformat` executable than described above, must make sure the executable has both `arm64` and `x86_64` support

3. Edit `mmuf-app-ios/Linting/swiftformat.version` with the updated version.

---
