#!/bin/bash

set -e

usage() {
  echo "Usage: ${0} <REQUIRED_FLAGS> [FLAGS] [-h]" >&2
  echo 'Required flags:' >&2
  echo '  -d  [str ]  Path to directory to copy artifact. Default is: /opt/llm_finetuning ' >&2
  echo '  -u  [str ]  SSH username' >&2
  echo '  -k  [path]  Path to private SSH key' >&2
  echo '  -a  [str ]  Address of login node (IP or domain name)' >&2
  echo '' >&2
  echo 'Flags:' >&2
  echo '  -p  [int ]  SSH port of login node.' >&2
  echo '              By default, 22' >&2
  echo '' >&2
  echo '  -h  Print help and exit' >&2
  exit 1
}

h1() { echo -e "$(tput setab 12)$(tput setaf 0)$(tput bold) ${1} $(tput sgr0)"; }
h2() { echo -e "$(tput setab 14)$(tput setaf 0)   ${1} $(tput sgr0)"; }
hdone() { echo -e "$(tput setab 10)$(tput setaf 0)   Done $(tput sgr0)"; }
herror() { echo -e "$(tput setab 1)$(tput bold) ERROR: ${1} $(tput sgr0)"; }

while getopts d:u:k:a:p:n:h flag
do
  case "${flag}" in
    d) DIR=${OPTARG};;
    u) USER=${OPTARG};;
    k) KEY=${OPTARG};;
    a) ADDRESS=${OPTARG};;
    p) PORT=${OPTARG};;
    h) usage;;
    *) usage;;
  esac
done

if [ -z "${USER}" ] || [ -z "${KEY}" ] || [ -z "${ADDRESS}" ]; then
  usage
fi

if [ -z "${PORT}" ]; then
  PORT=22
fi

if [ -z "${DIR}" ]; then
  DIR="/opt/llm_finetuning"
fi

h1 "Creating directory for LLM finetuning on ${ADDRESS}..."
ssh \
  -i "${KEY}" \
  -p "${PORT}" \
  "${USER}@${ADDRESS}" \
  mkdir -p "${DIR}/"
hdone

h1 "Transferring files as user '${USER}' with key '${KEY}' to ${ADDRESS}:${PORT}..."
scp \
  -i "${KEY}" \
  -P "${PORT}" \
  -r clean.sh finetuning.py run-finetuning-gpu16.sh run-finetuning-gpu1.sh \
  "${USER}@${ADDRESS}":"${DIR}/"
hdone