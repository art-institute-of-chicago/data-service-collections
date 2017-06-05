#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

rm "apiary.apib"

cd "blueprints"
ls | grep '^[^_]*.apib' | xargs rm
