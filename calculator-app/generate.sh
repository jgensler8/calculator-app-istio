#!/bin/sh

SCRIPT_ROOT="$PWD/$(dirname $0)"

SERVICES="tokenizer division-operator multiplication-operator subtraction-operator addition-operator"

if [ -z "${ENVIRONMENT}" ] ; then
  echo "ENVIRONMENT needs to be set."
  echo "Example: prod, preprod"
  exit
fi

TEMPLATE_DEST_DIR="${SCRIPT_ROOT}/templated"
TEMPLATE_SRC_DIR="${SCRIPT_ROOT}/templates"

if [ ! -d "${TEMPLATE_DEST_DIR}" ]; then
  mkdir -p "${TEMPLATE_DEST_DIR}"
else
  rm "${TEMPLATE_DEST_DIR}/"*
fi

# Usage
# templateResource data_file template_file output_file
templateResource () {
  echo "Templating ($3)"
  gotpl -data "$1" -template "$2" -output "$3"
}

# Usage
# templateService team_name service_name image_service template_src_directory template_dest_dir
templateService () {
  DATA_FILE="${SCRIPT_ROOT}/data.yaml"

  # echo "Creating template file for (${service}) in (${DATA_FILE})"
  cat > "${DATA_FILE}" <<EOF
---
replicas: "1"
logLevel: 6
environment: "${ENVIRONMENT}"
teamName: "team-$1"
serviceName: "$2"
imageRepo: "jgensl2"
imageService: "$3"
imageTag: "v0.1.1"
# portName: "my-http"
portName: "http"
version: "v1"
EOF

  for type in "deployment" "ingress" "service" "namespace" ; do
    templateResource "${DATA_FILE}" "$4/template-${type}.yaml" "$5/$1-$2-${type}.yaml"
  done
  for type in "route-rule" ; do
    templateResource "${DATA_FILE}" "$4/template-${type}.yaml" "${SCRIPT_ROOT}/istio-templated/$1-$2-${type}.yaml"
  done
}

for service in ${SERVICES} ; do
  templateService "${service}" "${service}" "${service}" "${TEMPLATE_SRC_DIR}" "${TEMPLATE_DEST_DIR}"
done

templateService "gateway" "gateway" "gateway" "${SCRIPT_ROOT}/gateway" "${TEMPLATE_DEST_DIR}"
templateService "multiplication-operator" "multiplication-operator-build-123" "multiplication-operator" "${TEMPLATE_SRC_DIR}" "${TEMPLATE_DEST_DIR}"
