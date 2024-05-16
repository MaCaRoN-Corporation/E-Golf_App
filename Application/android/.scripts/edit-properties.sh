#!/bin/bash
# Replace BRANCH_NAME with your branch name (i.e. main, master, dev, uat)
# If you want to use multiple branches, implement the code below multiple times with different branch names (i.e. one for main, one for dev, one for uat).

# Branch
# branch="$(git rev-parse --abbrev-ref HEAD)"
branch="dev"

echo ""
echo "Current Branch: $branch"
echo ""

if [ "$branch" != "main" ] && [ "$branch" != "dev" ]; then
  echo "You can't commit directly to the $branch branch"
  # exit 1
fi

if [ "$branch" = "main" ]; then
  echo "Changing the current build version type to RELEASE"
  sed -i 's/VERSION_TYPE=release/VERSION_TYPE=release/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=debug/VERSION_TYPE=release/' ./app/version.properties.txt
fi

if [ "$branch" = "dev" ]; then
  echo "Changing the current build version type to DEBUG"
  sed -i 's/VERSION_TYPE=release/VERSION_TYPE=debug/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=debug/VERSION_TYPE=debug/' ./app/version.properties.txt
fi