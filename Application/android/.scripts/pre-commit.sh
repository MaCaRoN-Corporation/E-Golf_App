#!/bin/bash
# Replace BRANCH_NAME with your branch name (i.e. main, master, dev, uat)
# If you want to use multiple branches, implement the code below multiple times with different branch names (i.e. one for main, one for dev, one for uat).

# Branch
branch="$(git rev-parse --abbrev-ref HEAD)"

echo ""
echo "Current Branch: $branch"
echo ""

if [ "$branch" != "main" ] && [ "$branch" != "dev" ]; then
  echo "You can't commit directly to the $branch branch"
  exit 1
fi

echo "You can commit directly to the $branch branch"

echo "*********************************************************"
echo "Running git pre-commit hook. Running Spotless Apply... "
echo "*********************************************************"

# Gather the staged files - to make sure changes are saved only for these files.
stagedFiles=$(git diff --staged --name-only)

# run spotless apply
./gradlew spotlessApply

status=$?

if [ "$status" = 0 ] ; then
    echo "Static analysis found no problems."
    # Add staged file changes to git
    for file in $stagedFiles; do
      if test -f "$file"; then
        git add $file
      fi
    done
    #Exit
    exit 0
else
    echo "*********************************************************"
    echo "       ********************************************      "
    echo 1>&2 "Spotless Apply found violations it could not fix."
    echo "Run spotless apply in your terminal and fix the issues before trying to commit again."
    echo "       ********************************************      "
    echo "*********************************************************"
    #Exit
    exit 1
fi