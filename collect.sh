#!/bin/bash

usage() {
  echo "Usage: collect.sh <org> <folder>"
}

if [ $# -lt 2 ]; then
  usage >&2
  exit 1
fi

org=$1
folder=$2

echo "Fetching repositories in $org"
repos=$(gh api /orgs/$org/repos --paginate --jq '.[].name')
for repo in $repos; do
  echo "Collecting $repo"
  actionfilename="action.yml"
  action=$(gh api -H 'accept: application/vnd.github.v3.raw' "repos/$org/$repo/contents/$actionfilename") || false
  if [ $? -ne 0 ]; then       
   actionfilename="action.yaml"
   action=$(gh api -H 'accept: application/vnd.github.v3.raw' "repos/$org/$repo/contents/$actionfilename") || false
  fi

  if [ "$?" -eq "0" ]
  then
    name=$(echo "$action" | shyaml -q get-value name)
    description=$(echo "$action" | shyaml -q get-value description)
    author=$(echo "$action" | shyaml -q get-value author "")

    readme=$(gh api -H 'accept: application/vnd.github.v3.raw' "repos/$org/$repo/readme") || false
    
    tags=$(gh api /repos/$org/$repo/git/refs/tags --paginate --jq .[].ref)
    versions=""
    for tag in $tags; do
      tag=$(echo $tag | cut -d/ -f3)
      versions+=" - $tag\n"     
    done

    echo -e "---\nname: $name\ndescription: $description\nrepo: $org/$repo\nauthor: $author\nmetadata: $actionfilename\nversions:\n$versions---\n\n$readme" > $folder/$repo.md
  else
    echo "> Unable to fetch action.yaml|yml from the $repo"
    continue
  fi

done