- git clone "" 拉取仓库到本地
- git commit 提交代码到仓库
- git brach \<name> 创建新的分支（比如在一个公共的大工程中，需要每个人编写自己独立的模块再合并到一起执行，就需要先创建分支）
- git checkout \<name> 切换到新的分支上
- git checkout -b \<name> 创建并切换到新的分支上，相当于上面brach和checkout命令的结合
- git merge \<name> 当前应该处于git的一个分支上，若要进行合并，应该要使该分支和与该分支有同一个父节点的分支才能合并，执行该命令之后，另一个分支就和该分支一起建立了一个新的结果
- git rebase \<name> 当前处于gti的一个分支上，rebase可以使与该分支并行开发的分支提交后看上去像是线性开发的，即使该分支成为另一个并列分支的后续
- git head




# How to push
```bash
git status

git add xxx/xxx.py

git status

git commit

gitdir=$(git rev-parse --git-dir); scp -p -P 29418 gerrit-spsd.verisilicon.com:hooks/commit-msg ${gitdir}/hooks/

（git bash）gitdir=$(git rev-parse --git-dir); scp -O -P 29418 gerrit-spsd.verisilicon.com:hooks/commit-msg ${gitdir}/hooks/

git commit --amend

git push origin HEAD:refs/for/master
```
if need to revise last commit:
```bash
git status
git add .
git commit --amend
git push origin HEAD:refs/for/master
```
如果push错了，可以reset
```shell
git reset --hard HEAD^
```
如果在commit之前，就软重置
```shell
git reset --soft HEAD^
```





