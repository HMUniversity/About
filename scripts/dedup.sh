#!/bin/bash
gh issue list --limit 1000 --json author --jq '.[].author.login' | \
sort | uniq -d | \
xargs -I {} sh -c 'gh issue list --author "{}" --json number --jq ".[].number" | sed "1d" | xargs -I % gh issue close %'