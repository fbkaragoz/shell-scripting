#!/bin/bash
vartrans=''

read -r vartrans

if [ -z "$vartrans" ]; then
  echo 'Not yet provided. Exiting.'
  exit 1
fi

echo 'Translating...'

buffer_trans=$(trans --source-lang ar --target tr "$vartrans")

echo "$buffer_trans"
