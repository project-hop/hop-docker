#!/bin/bash
#
# script to download the hop package and unzip it to the current folder.
# steps:
# - download maven metadata to determine latest version - this will define the folder to download from
# - download maven metadata from the folder determined above, to detrmine the package version
# - variable HOP_LATEST_VERSION will be exported
# - variable HOP_LATEST_ZIP will be exported
# - remove metadata files and zip file
#
# uwe geercken - 2020-05-10
# adjusted for project hop docker by DS 2020-05-15
#

# NOT USED ANY MORE - REPLACED BY resources/get-hop.sh


# SCRIPT_DIR="$(dirname "$(readlink -f "$0")")" -- doesn't work on macos
SCRIPT_DIR="$( cd "$( /usr/bin/dirname "$0" )" && pwd )"
MAVEN_METADATA_XML=latest_maven-metadata.xml
PACKAGE_XML=latest_hop_package.xml
DOWNLOAD_DIR=${SCRIPT_DIR}/../resources
LATEST_VERSION_FILE=${DOWNLOAD_DIR}/latest_downloaded_version.info


# download url
URL="https://artifactory.project-hop.org/artifactory/hop-snapshots-local/org/hop/hop-assemblies-client"

#echo "[INFO] getting maven metadata from: ${url}"
curl -s -o "${MAVEN_METADATA_XML}" ${URL}/maven-metadata.xml

# find the latest latest package version in the maven metadata file
MAVEN_METADATA_LATEST_HOP_VERSION_XML=$(xmllint --xpath '//versioning/latest' "${MAVEN_METADATA_XML}")
# stripping the tags
MAVEN_METADATA_LATEST_HOP_VERSION=$(echo $MAVEN_METADATA_LATEST_HOP_VERSION_XML | sed 's/<latest>//' | sed 's/<\/latest>//')

# full url to the package
FULL_URL=${URL}/${MAVEN_METADATA_LATEST_HOP_VERSION}

#echo "[INFO] getting maven metadata about package from: ${FULL_URL}"
curl -s -o "${PACKAGE_XML}" ${FULL_URL}/maven-metadata.xml

# finding the version in the maven xml file
VERSION_XML=$(xmllint --xpath '//snapshotVersion/extension[text()="zip"]/../value' "${PACKAGE_XML}")
# stripping the tags
VERSION=$(echo $VERSION_XML | sed 's/<value>//' | sed 's/<\/value>//')

# export variable
export HOP_LATEST_VERSION=${VERSION}
echo "Latest version: ${HOP_LATEST_VERSION}"
echo "Latest version file: ${LATEST_VERSION_FILE}"
# construct full zip file name
ZIP_FILENAME="hop-assemblies-client-${VERSION}.zip"
export HOP_LATEST_ZIP=${ZIP_FILENAME}

#echo "[INFO] latest hop version zip file: ${ZIP_FILENAME}"

# check if we had a previous download
if [ -f ${LATEST_VERSION_FILE} ]
then
	PREVIOUS_DOWNLOAD=$(cat ${LATEST_VERSION_FILE})
  echo "Previous version: ${PREVIOUS_DOWNLOAD}"
  echo "Current version: ${LATEST_VERSION_FILE}"
fi

# download file if not previously done for the latest version
if [ "${ZIP_FILENAME}" != "${PREVIOUS_DOWNLOAD}" ]
then
	# download zip file
	echo "[INFO] downloading: ${ZIP_FILENAME}"
	curl -s -o ${DOWNLOAD_DIR}/${ZIP_FILENAME} ${FULL_URL}/${ZIP_FILENAME}
  # remove previously extracted version of hop
  rm -rf ${DOWNLOAD_DIR}/hop
  unzip ${DOWNLOAD_DIR}/${ZIP_FILENAME} -d ${DOWNLOAD_DIR}
  # rm ${DOWNLOAD_DIR}/${ZIP_FILENAME}

	# save the latest version info to a file
	echo "${ZIP_FILENAME}" > ${DOWNLOAD_DIR}/${LATEST_VERSION_FILE}
else
	echo "[INFO] latest version already downloaded: ${ZIP_FILENAME}"
fi

#echo "[INFO] removing maven metadata files"
rm "${MAVEN_METADATA_XML}"
rm "${PACKAGE_XML}"
