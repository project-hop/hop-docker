#!/bin/bash
# Script used to fetch the latest snapshot version of project hop

#Branch name variable
echo Branch Parameter: ${BRANCH_NAME}

# Artifactory location
server=https://artifactory.project-hop.org/artifactory

# Use Snapshot when branch is master else latest release
if [[ "${BRANCH_NAME}" = "master" ]]
then
    repo=hop-snapshots
else
    repo=hop-releases
fi

# Maven artifact location
name=hop-assemblies-client
artifact=org/hop/$name
path=$server/$repo/$artifact
version=$(curl -s $path/maven-metadata.xml | grep latest | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/")
echo version: $version
build=$(curl -s $path/$version/maven-metadata.xml | grep '<value>' | head -1 | sed "s/.*<value>\([^<]*\)<\/value>.*/\1/")
echo build: $build

#If build is empty then use version (release)
if [ -z "$build" ]
then
    build=$version
fi

zip=$name-$build.zip
url=$path/$version/$zip

# Download
echo $url
curl -q -N $url -o ${DEPLOYMENT_PATH}/hop.zip

# Unzip
unzip ${DEPLOYMENT_PATH}/hop.zip -d ${DEPLOYMENT_PATH}
chmod -R 700 ${DEPLOYMENT_PATH}/hop

# Cleanup
rm ${DEPLOYMENT_PATH}/hop.zip

