# Bash-09-grade-report

# Problem statement
- mkdproject.sh was not found in my machine , it showed just (No such file directory). so i had to create it by hand with mkdir -p, touch, and git init .

- values like 19 broke comparisons. Same trim functions all along .

- I made somen wrong files name like i typed grade.sh instead of grades.sh. That is to say the exact name matters.

## Project Goals
- To show the class average at the bottom

- Rank students from best to worst in an aligned table with no mistake.

- To read the CVS file of each student score and calculate each of thi

- Also to practice bash , git branches, pull requests.

## Tech stack
- **Bash** : the script itself ('garde.sh')

- **awk** : a decimal math for averages.

- **Git and Github** : the version control, branches, and the pull request.

- **VS Code and Terminal** : where I wrote my code and ran everything.

## Screenshoot
![Grade report output](assets/images/output.png)

## Features
-  Give a mention : Tres bien, Bien, Assez bien, Passable or Echec.

- Show the class average in the footer.

- Show howmany lines are skipped.

- Prints aligned colums with 'prinf'.

## Testing
- I ran three quick test before submitting.'messy.cvs' it my own practice file.
## Installation and setup
- Clone the repository:
   '''bash
   git clone https://github.com/Fokeng126/bash-09-grade-report.git 

  - cd bash-09-grade-report
  - chmod +x grades.sh
  - ./grades.sh grades.cvs
    '''

    ## Challenges faced
  -  **Wrong file name.** I first wrote `grade.sh` instead of `grades.sh`. I renamed it so it matches the project requirements.

  - **Decimals in bash.** Bash could not compare numbers like 16.50.So I used `awk` for the average and compared the total out of 80 for the mention.

  - **`mkproject.sh` was not found.** The tool was not on my machine, so I created the project folders and files by hand with `mkdir -p`, `touch` and `git init`.

  ## What I learned 
  - How to validate input and skip bad lines with a warning on stderr.

  - How to work with git: branches, commits, and pull requests
  - How to debug step by step (for example, finding that `grades.csv` was empty).

  - I learned how, how to read a CSV file line by line in bash with `while read` and `IFS=','

  ## Author.
   - ## Author

**Fokeng Joshua Kroos** Junior Developer
GitHub: [@Fokeng126](https://github.com/Fokeng126)
Rebase Day 9 project: Grade report.

[def]: ../../..