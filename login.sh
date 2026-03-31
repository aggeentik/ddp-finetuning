#!/bin/bash

set -e

usage() { echo "usage: ${0} [-u <ssh_user>] -k <path_to_ssh_key> -a <ip_address> [-h]" >&2; exit 1; }

while getopts u:k:a:p:n:h flag
do
    case "${flag}" in
        u) user=${OPTARG};;
        k) key=${OPTARG};;
        a) address=${OPTARG};;
        h) usage;;
        *) usage;;
    esac
done

if [ -z "${key}" ]; then
    usage
fi

if [ -z "${address}" ]; then
    usage
fi

if [ -z "${user}" ]; then
    user=root
fi

ssh -i "${key}" -p 22 "${user}"@"${address}"
