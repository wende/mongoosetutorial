#!/bin/bash

command -v erl >/dev/null 2>&1 || { echo >&2 "Erlang required but not installed. Aborting."; exit;};
echo "Erlang installed ✓"
command -v iex >/dev/null 2>&1 || { echo >&2 "Iex required but not installed. Aborting."; exit;};
echo "Iex works ✓"
command -v elixir >/dev/null 2>&1 || { echo >&2 "Elixir required but not installed. Aborting."; exit;};
echo "Elixir installed ✓"
command -v mix >/dev/null 2>&1 || { echo >&2 "Mix required but not installed. Aborting."; exit;};
echo "Mix installed ✓"
r=$(mix help | grep phoenix | wc -l);
if [[ $r =~ "9" ]]; then
    echo -e "${Gre}Phoenix installed ✓" 
else
    echo "ERROR: ** ${Red}Phoenix not installed!"
    exit
fi
command -v mongooseimctl >/dev/null 2>&1 || { echo >&2 "Mongooseim required but not installed. Aborting."; exit;};
echo "Mongooseim installed ✓"
echo "Alright! Everything looks fine ✓";
