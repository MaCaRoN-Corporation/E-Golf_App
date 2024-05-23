#!/bin/bash
# Replace BRANCH_NAME with your branch name (i.e. main, master, dev, uat)
# If you want to use multiple branches, implement the code below multiple times with different branch names (i.e. one for main, one for dev, one for uat).

# Branch
branch="$(git rev-parse --abbrev-ref HEAD)"

echo ""
echo "Current Branch: $branch"
echo ""

# if [ "$branch" != "main" ] && [ "$branch" != "rqt" ] && [ "$branch" != "dev" ]; then
#   echo "You can't commit directly to the $branch branch"
#   exit 1
# fi

if [ "$branch" = "main" ]; then
  echo "Changing the current build version type to PRODUCTION"
  sed -i 's/VERSION_TYPE=production/VERSION_TYPE=production/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=beta/VERSION_TYPE=production/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=alpha/VERSION_TYPE=production/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=internal/VERSION_TYPE=production/' ./app/version.properties.txt
elif [ "$branch" = "rqt" ]; then
  echo "Changing the current build version type to BETA"
  sed -i 's/VERSION_TYPE=production/VERSION_TYPE=beta/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=beta/VERSION_TYPE=beta/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=alpha/VERSION_TYPE=beta/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=internal/VERSION_TYPE=beta/' ./app/version.properties.txt
elif [ "$branch" = "dev" ]; then
  echo "Changing the current build version type to ALPHA"
  sed -i 's/VERSION_TYPE=production/VERSION_TYPE=alpha/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=beta/VERSION_TYPE=alpha/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=alpha/VERSION_TYPE=alpha/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=internal/VERSION_TYPE=alpha/' ./app/version.properties.txt
else
  echo "Changing the current build version type to INTERNAL"
  sed -i 's/VERSION_TYPE=production/VERSION_TYPE=internal/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=beta/VERSION_TYPE=internal/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=alpha/VERSION_TYPE=internal/' ./app/version.properties.txt
  sed -i 's/VERSION_TYPE=internal/VERSION_TYPE=internal/' ./app/version.properties.txt
fi