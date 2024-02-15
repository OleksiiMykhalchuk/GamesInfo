#!/bin/bash

# Xcode trailing whitespace settings
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool YES
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool YES

# Xcode indentation settings
defaults write com.apple.dt.Xcode DVTTextIndentTabWidth -int 4
defaults write com.apple.dt.Xcode DVTTextIndentWidth -int 4

# Project directory path
projectFolder=$SRCROOT
cd $projectFolder

# Repo directory paths paths
repoRoot=$(git rev-parse --show-toplevel)
lintingFolder="$repoRoot/Linting"

# Linter executable paths
swiftformat="$lintingFolder/swiftformat"
swiftlint="$lintingFolder/swiftlint"

# Linting config files
swiftformatConfig="$lintingFolder/swiftformat.yml"
swiftlintConfig="$lintingFolder/swiftlint.yml"

# Linting version files
swiftformatVersionFile="$lintingFolder/swiftformat.version"
swiftlintVersionFile="$lintingFolder/swiftlint.version"
expectedSwiftFormatVersion=$(cat "$swiftformatVersionFile")
expectedSwiftLintVersion=$(cat "$swiftlintVersionFile")

# Output
outputFolder="$lintingFolder/Reports"
mkdir -p $outputFolder
swiftformatOutput="$outputFolder/swiftformat-report.json"
swiftlintOutput="$outputFolder/swiftlint-report.json"

# SwiftFormat execution
echo "SwiftFormat:"
if test -f "$swiftformat"; then
    version=$("$swiftformat" --version)

    echo $version

    if [[ $version == *"$expectedSwiftFormatVersion"* ]]; then
        # Run command
        # - argument: must be the path to directory that contains the *xcode project file*
        # - option config: path to config file
        # - option lint: don't auto correct code
        # - option lenient: don't fail build job
        # - option exclude: excluded from linting (not sure why this is broken if set in config file)
        # - option report: output path

        # Lint project folder
        "$swiftformat" "$projectFolder" --config "$swiftformatConfig" --lint --lenient --exclude "Pods/**" --report "$swiftformatOutput"
    else
        echo "warning: incorrect SwiftFormat version installed. Expected $expectedSwiftFormatVersion at: $swiftformat. Found $version."
    fi
else
    echo "warning: missing SwiftFormat executable, expected at: $swiftformat"
fi

# Swiftlint execution
echo "SwiftLint:"
if test -f "$swiftlint"; then
    version=$($swiftlint version)

    if [[ $version == *"$expectedSwiftLintVersion"* ]]; then
        # Run command
        # - option config: path to config file
        # - option lenient: don't fail build job
        # - option path: root directory to lint from
        # - option reporter: output format (default: xcode)

        # Lint, output to xcode
        "$swiftlint" --config "$swiftlintConfig" --lenient --path "$projectFolder"

        # Lint, output to json file
        "$swiftlint" --config "$swiftlintConfig" --lenient --path "$projectFolder" --reporter "json" > "$swiftlintOutput"
    else
        echo "warning: incorrect SwiftLint version installed. Expected $expectedSwiftLintVersion at: $swiftlint. Found $version."
    fi
else
    echo "warning: missing SwiftLint executable, expected at: $swiftlint"
fi
