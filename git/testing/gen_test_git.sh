#!/bin/bash

# script to create a test git area

if [ -z $1 ]; then
    echo "Usage: gen_test_git.sh <base dir>"
    echo "Description: This script creates a local sandbox in which"
    echo "             you can test git commands."
    exit 1
fi

top_dir=$(pwd)
base_dir=${top_dir}/${1}
local_dir=${top_dir}/${1}/local
remote_dir=${top_dir}/${1}/remote/sandbox.git
initial_file=first_file.txt

# create directories
mkdir -p ${local_dir} ${remote_dir}

# make remote git
pushd ${remote_dir} >> //dev/null 2>&1
git init --bare --shared >> //dev/null 2>&1
git config receive.denyDeletes true >> //dev/null 2>&1
git config receive.denyNonFastForwards true >> //dev/null 2>&1
popd >> //dev/null 2>&1

# clone the git and add an initial file
pushd ${local_dir} >> //dev/null 2>&1
git clone ${remote_dir} sandbox1 >> //dev/null 2>&1
popd >> //dev/null 2>&1

pushd ${local_dir}/sandbox1 >> //dev/null 2>&1
echo "first file" > ${initial_file}
git add ${initial_file} >> //dev/null 2>&1
git commit -m 'first file' >> //dev/null 2>&1
git push origin master:master >> //dev/null 2>&1
git push origin master:branch1 >> //dev/null 2>&1
git push origin master:branch2 >> //dev/null 2>&1
popd >> //dev/null 2>&1

# clone a second copy
pushd ${local_dir} >> //dev/null 2>&1
git clone ${remote_dir} sandbox2 >> //dev/null 2>&1
popd >> //dev/null 2>&1

# print notes
echo "You have created a git sandbox area for testing. This is a great place to test"
echo "git commands in a totally safe area. The two local cloned workspaces are at:"
echo ""
echo "    * ${local_dir}/sandbox1"
echo "    * ${local_dir}/sandbox2"
echo ""
echo "If you want to look at the bare remote repository (which looks like a git remote server):"
echo ""
echo "    * ${remote_dir}"
echo ""
echo "There are 3 branches in this git:"
echo ""
echo "    * master"
echo "    * branch1"
echo "    * branch2"
echo ""
echo "Try out git commands either or both of the local workspaces. You can push changes to the"
echo "remote and see what happens. This is a great place to test things before trying"
echo "them in a real repository."
