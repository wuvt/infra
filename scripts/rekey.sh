#!/usr/bin/env bash

set -euo pipefail

export AGENIX_RULES=./agenix-rules.nix

age-plugin-fido2-hmac --magic-identity > /tmp/rk_id

for s in ./secrets/*.age; do
	EDITOR=: agenix -e "$s" --identity /tmp/rk_id
done

rm -f /tmp/rk_id
