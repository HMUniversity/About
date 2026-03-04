#!/bin/bash

ORG_NAME="HMUniversity"

COMMENT_BODY="Hi,
Congratulations! Your application has been accepted and the offer has been sent to your mail. Please confirm the offer or the invitation within 7 days.

Regards,
Home University"

echo "[INFO] getting issue list..."
issues=$(gh issue list --limit 1000 --state open --json number,author --jq '.[] | "\(.number) \(.author.login)"')

if [ -z "$issues" ]; then
    echo "[ERROR] no open issues found."
    exit 0
fi

echo "$issues" | while read -r issue_num user_id; do
    echo "[INFO] processing Issue #$issue_num | user: $user_id"
    gh api -X PUT "orgs/$ORG_NAME/memberships/$user_id" -f role='member' > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        gh issue close "$issue_num" --comment "$COMMENT_BODY"
        echo "[ OK ] closed Issue #$issue_num and commented on it."
    else
        echo "[FAIL] failed to send invitation (user may already be in the organisation or insufficient permissions)."
    fi
done