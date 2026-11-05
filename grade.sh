#!/bin/bash

usage() {
    echo "Usage: grades.sh FILE.csv" >&2
    exit 1
}

# Remove Windows \r and spaces around a value
trim() {
    sed 's/\r//g; s/^[[:space:]]*//; s/[[:space:]]*$//'
}

# Checking if a score is from 0 to 20
is_valid_score() {
    [[ "$1" =~ ^([0-9]|1[0-9]|20)$ ]]
}

# Give the student a mention
get_mention() {
    local total="$1"

    if (( total >= 64 )); then
        echo "Très bien"

    elif (( total >= 56 )); then
        echo "Bien"

    elif (( total >= 48 )); then
        echo "Assez bien"

    elif (( total >= 40 )); then
        echo "Passable"

    else
        echo "Échec"
    fi
}

# Checking if one file was given
if [[ $# -ne 1 ]]; then
    usage
fi

file="$1"

#Checking if file can be read or exists
if [[ ! -r "$file" ]]; then
    echo "Error: cannot read file '$file'" >&2
    exit 1
fi

# Creating temporary file for sorting
tmp=$(mktemp)

line_num=1
skipped=0
valid=0
grand_total=0

# Open and read the CSV file
{
    # Skip the header
    read -r _

    while IFS=',' read -r raw_name raw_html raw_css raw_bash raw_git || [[ -n "$raw_name$raw_html$raw_css$raw_bash$raw_git" ]]; do

        ((line_num++))

        # Cleaning spaces and Windows \r
        name=$(printf '%s' "$raw_name" | trim)
        html=$(printf '%s' "$raw_html" | trim)
        css=$(printf '%s' "$raw_css" | trim)
        bash_score=$(printf '%s' "$raw_bash" | trim)
        git_score=$(printf '%s' "$raw_git" | trim)

        # complete line should be ignored completely if all fields are empty
        if [[ -z "$name$html$css$bash_score$git_score" ]]; then
            continue
        fi

        # Checking  missing name
        if [[ -z "$name" ]]; then
            echo "Warning: line $line_num skipped (missing name)" >&2
            ((skipped++))
            continue
        fi

        # Checking all scores
        bad=0

        for score in "$html" "$css" "$bash_score" "$git_score"; do

            if [[ -z "$score" ]]; then
                echo "Warning: line $line_num skipped (missing score)" >&2
                bad=1
                break
            fi

            if ! is_valid_score "$score"; then
                echo "Warning: line $line_num skipped (invalid score '$score')" >&2
                bad=1
                break
            fi

        done

        #Invalid line, skip to next iteration
        if (( bad == 1 )); then
            ((skipped++))
            continue
        fi

        # Calculate the total
        total=$((html + css + bash_score + git_score))

        # Calculate the average
        avg=$(awk -v total="$total" 'BEGIN {
            printf "%.2f", total / 4
        }')

        # Get the mention
        mention=$(get_mention "$total")

        # Save the student information for sorting
        echo "$avg|$name|$html|$css|$bash_score|$git_score|$mention" >> "$tmp"

        ((valid++))
        ((grand_total += total))

    done

} < "$file"

# Print the table header
printf "%-4s  %-16s %4s %4s %4s %4s %6s  %s\n" \
    "RANK" "NAME" "HTML" "CSS" "BASH" "GIT" "AVG" "MENTION"

# Start ranking from 0
rank=0

# Sort by average, highest first
sort -t'|' -k1,1 -rn "$tmp" | while IFS='|' read -r avg name html css bash_score git_score mention; do

    ((rank++))

    printf "%4d  %-16s %4s %4s %4s %4s %6s  %s\n" \
        "$rank" "$name" "$html" "$css" "$bash_score" "$git_score" "$avg" "$mention"

done

# Remove the temporary file
rm "$tmp"

printf '%s\n' '------------------------------------------------------------'

# Calculate the class average
if (( valid > 0 )); then

    class_avg=$(awk -v total="$grand_total" -v students="$valid" 'BEGIN {
        printf "%.2f", total / (students * 4)
    }')

    echo "Class average: $class_avg"

else
    echo "Class average: n/a (no valid students)"
fi

echo "Skipped $skipped invalid lines (see warnings above)"
