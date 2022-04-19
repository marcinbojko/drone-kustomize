#!/bin/bash
release=$(grep -i "LABEL RELEASE" Dockerfile|awk '{print $2}'|cut -d\" -f2)
version=$(grep -i "LABEL VERSION" Dockerfile|awk '{print $2}'|cut -d\" -f2)
maintainer=$(grep -i "LABEL MAINTAINER" Dockerfile|awk '{print $2}'|cut -d\" -f2)
if [ -n "$version" ] && [ -n "$release" ] && [ -n "$maintainer" ]; then
  echo Version: "$version" found
  echo Release: "$release" found
  echo maintainer: "$maintainer" found
  docker login
  docker tag "$release:$version" "$maintainer/$release:$version"
  docker tag "$release:$version" "$maintainer/$release:latest"
  docker push "$maintainer/$release:$version"
  docker push "$maintainer/$release:latest"
else
 echo Version or Release or Maintainer tag is empty
 exit 1
fi
