#! /usr/bin/env bash

set -Eeuo pipefail

sort-package-json &&
	npm install &&
	npm run prettify &&
	npm run standardize
