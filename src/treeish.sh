#!/usr/bin/env bash

set -euo pipefail

# usage messsage 
# will be updated later

treeish_usage() {
	cat <<EOF

Usage: $(basename "$0") [--gitignore] [DIR]

Print a simple tree-like structure.

Options:
	--gitignore	Respect .gitignore via 'git ls-files'
			( only works inside of a git repository )

If DIR is not given, defaults to current directory.
EOF
}

treeish_render_from_list() {
	awk '
		BEGIN { FS="/" }
		{
			path = ""
			for ( i = 1; i<= NF; i++) {
				path = ( i == 1 ? $i : path "/" $i)
				if (!(path in seen)) {
					indent = ""
					for ( j = 1; j < i; j++) indent = indent " "
					print indent $i
					seen[path] = 1
				}
			}

		}
	'
}


treeish_all() {
	local_dir="$1"
	(
	cd "$dir" || { echo "Cannot cd into '$dir'" >&2; exit 1; }

	find . -mindepth 1 -printf "%P\n" \
		| sort \
		| treeish_render_from_list
	)
}

treeish_gitignore() {
	local dir="$1"
	(
		cd "$dir" || { echo "Cannot cd into '$dir'" >&2; exit 1; }

		if ! git rev-parse --llis-inside-work-tree >/dev/null 2>&1; then
			echo "Error: --gitignore mode requires being inside a git repo." >&2
			exit 1
		fi

		git ls-files --cached --others --exclude-standard \
			| sort \
			| treeish_render_from_list
	)
}


# --- argument parsing and entrypoint --- #

mode="all"
dir="."

while [[ "${1-}" =~ ^- ]]; do
	case "$1" in
		--gitignore)
			mode="git"
			shift
			;;
		-h|help)
			treeish_usage
			exit 0
			;;
		*)
			echo "Unknown option: $1" >&2
			treeish_usage
			exit 1
			;;
		esac
	done

# optional dir
if [[ "${1-}" != "" ]]; then
	dir="$1"
fi

case "$mode" in
	all) treeish_all "$dir" ;;
	git) treeish_gitignore "$dir" ;;
	*) echo "Internal error: unknown mode '$mode'" >&2; exit 1 ;;
esac















