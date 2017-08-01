#!/usr/bin/env bash

set -x
set -e

INPUT_PATH=$1
OUTPUT_PATH=${2:-.}

PACKAGE_NAME=indy-anoncreds
POSTINST_TMP=postinst-${PACKAGE_NAME}
PREREM_TMP=prerm-${PACKAGE_NAME}

cp postinst ${POSTINST_TMP}
cp prerm ${PREREM_TMP}
sed -i 's/{package_name}/'${PACKAGE_NAME}'/' ${POSTINST_TMP}
sed -i 's/{package_name}/'${PACKAGE_NAME}'/' ${PREREM_TMP}

fpm --input-type "python" \
    --output-type "deb" \
    --verbose \
    --architecture "amd64" \
    --python-package-name-prefix "python3" \
    --python-bin "/usr/bin/python3" \
    --exclude "*.pyc" \
    --exclude "*.pyo" \
    --maintainer "Hyperledger <hyperledger-indy@lists.hyperledger.org>" \
    --after-install ${POSTINST_TMP} \
    --before-remove ${PREREM_TMP} \
    --name ${PACKAGE_NAME} \
    --package ${OUTPUT_PATH} \
    ${INPUT_PATH}

rm ${POSTINST_TMP}
rm ${PREREM_TMP}
