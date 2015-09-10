#!/bin/bash
Gre='\e[0;32m'
Red='\e[0;31m'

command -v erl >/dev/null 2>&1 || { echo -e >&2 "${Red}Erlang required but not installed. Aborting."; exit;};
echo -e "${Gre}Erlang installed ✓"
command -v iex >/dev/null 2>&1 || { echo -e >&2 "${Red}Iex required but not installed. Aborting."; exit;};
echo -e "${Gre}Iex works ✓"
command -v elixir >/dev/null 2>&1 || { echo -e >&2 "${Red}Elixir required but not installed. Aborting."; exit;};
echo -e "${Gre}Elixir installed ✓"
command -v mix >/dev/null 2>&1 || { echo -e >&2 "${Red}Mix required but not installed. Aborting."; exit;};
echo -e "${Gre}Mix installed ✓"
r=$(mix help | grep phoenix);
if [[ $r =~ "mix phoenix.new" ]]; then
    echo -e "${Gre}Phoenix installed ✓" 
else
    echo -e "${Red}ERROR: ** Phoenix not installed!"
    exit
fi
command -v mongooseimctl >/dev/null 2>&1 || { echo -e >&2 "Mongooseim required but not installed. Aborting."; exit;};
echo -e "${Gre}Mongooseim installed ✓"
command -v node >/dev/null 2>&1 || { echo -e >&2 "[Warging] Node.js recommended but not installed. Aborting."; exit;};
echo -e "${Gre}Node.js installed ✓"
command -v npm >/dev/null 2>&1 || { echo -e >&2 "[Warging] Npm recommended but not installed";};
echo -e "${Gre}Npm installed ✓"


echo -e "\s Alright! Everything looks fine!";
