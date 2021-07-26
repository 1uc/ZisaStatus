#! /usr/bin/env bash

# for d in ZisaCore ZisaMemory ZisaMPI ZisaTimeStepping ZisaSFC ZisaFVM Zisa
for d in Zisa ZisaCore
do
  github_io=$(wget -r -nv --spider https://1uc.github.io/${d} 2>&1)

  readme_md=$(mktemp -t tmp-readme.XXXXXXXX)
  wget https://raw.githubusercontent.com/1uc/${d}/main/README.md -O ${readme_md} 2>/dev/null

  readme=$(~/.npm/bin/markdown-link-check ${readme_md} 2>&1)
  readme_status=$?

  github_status=$(echo "${github_io}" | grep 'Found no broken links.')

  if [[ -n ${github_status} && ${readme_status} -eq 0 ]]
  then
    echo "${d}: OK"
  else
    log=$(mktemp -t tmp-wget.XXXXXXXX)
    echo "${github_io}" >> $log
    echo "-----------------------------" >> $log
    echo "${readme}" >> $log

    echo "${d}: BROKEN, see ${log}"
  fi
done
