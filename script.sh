#!/bin/bash
new_word="NEW_WORD"
sed "s/postgres-X/$new_word/g" postgres.nomad.hcl > "$new_word.nomad.hcl"