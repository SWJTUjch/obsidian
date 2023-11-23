# New coding style
New coding style check is based on precommit and using VSI/build to finally call precommit.

## How to setup local environment

* Get minimum code for repo

```
repo init --no-clone-bundle -u ssh://gerrit-spsd.verisilicon.com:29418/manifest --repo-url=ssh://gerrit-spsd.verisilicon.com:29418/git-repo -b spsd/master -g default -m common.xml
repo sync
```
* run build upgrade once, check if run-pre-commit.sh exsits in ~/.local/bin after execute below command

```
cd build
./build.sh gc1 upgrade=1
```
* Add ~/.local/bin into PATH if it does not in PATH

```
export PATH=/home/<user>/.local/bin:$PATH
or add it into ~/.bashrc
```
* run pre commit for Automation to check coding style

```
cd Automation
run-pre-commit.sh 
```

* run pre commit for Automation to check coding style for specific file or folder

```
cd Automation
run-pre-commit.sh file=xx/xx/xx
```
* Check and edit coding style check item in Automation/.hook_opt

```
SKIP=name-tests-test
SKIP=shebang
HOOK=shellcheck
HOOK=yapf
HOOK=pylint
```

## How to verify on CL

Add comment in gerrit CL
```
verify_gc1/precommit
```