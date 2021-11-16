#!/bin/bash

usage() {
  echo "Usage: collect.sh <org>"
}

if [ $# -lt 1 ]; then
  usage >&2
  exit 1
fi

org=$1
> actions.yaml

echo "Fetching repositories in $org"
repos=$(gh api /orgs/$org/repos --paginate --jq '.[].full_name')
for repo in $repos; do
  echo "Collecting $repo"
  actionfilename="action.yml"
  action=$(gh api -H 'accept: application/vnd.github.v3.raw' "repos/$repo/contents/$actionfilename") || false
  if [ $? -ne 0 ]; then       
   actionfilename="action.yaml"
   action=$(gh api -H 'accept: application/vnd.github.v3.raw' "repos/$repo/contents/$actionfilename") || false
  fi

  if [ "$?" -eq "0" ]
  then
    name=$(echo "$action" | shyaml -q get-value name)
    description=$(echo "$action" | shyaml -q get-value description)
    echo -e "- name: $name\n  description: $description\n  repo: $repo\n  metadata: $actionfilename\n" >> actions.yaml    
  else
    echo "> Unable to fetch action.yaml|yml from the $repo"
    continue
  fi

done