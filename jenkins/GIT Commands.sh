GIT Commands 

Basic Git Commands
Command	Description
    git init	Initialize a new Git repository
    git clone <url>	Clone a repository into a new directory
    git status	Show the working directory status
    git add <file>	Stage file(s) for commit
    git add .	Stage all changes (new, modified, deleted files)
    git commit -m "msg"	Commit staged changes with a message
    git log	View commit history
    git diff	Show unstaged changes
    git diff --staged	Show staged changes
    git config	Configure Git settings (name, email, editor, etc.)
    git help <command>	Show help for a Git command
🔁 Branching & Merging
    Command	Description
    git branch	List local branches
    git branch <name>	Create a new branch
    git checkout <branch>	Switch to another branch
    git switch <branch>	Modern alternative to checkout
    git checkout -b <name>	Create and switch to a new branch
    git merge <branch>	Merge another branch into the current one
    git branch -d <branch>	Delete a branch
    git branch -D <branch>	Force delete a branch
🔄 Rebase
    Command	Description
    git rebase <branch>	Reapply commits on top of another base branch
    git rebase -i HEAD~n	Interactively edit last n commits
    git pull --rebase	Rebase local commits on top of pulled changes
🔍 Viewing Changes
Command	Description
    git show	Show a commit or object
    git blame <file>	Show who last modified each line of a file
    git log --oneline	Condensed commit history
    git log --graph	ASCII graph of branch history
⬆️ Pushing & Pulling
Command	Description
    git remote -v	Show remote URLs
    git remote add <name> <url>	Add a new remote
    git fetch	Fetch changes from the remote
    git pull	Fetch and merge changes from the remote
    git push	Push changes to remote
    git push -u origin <branch>	Push and set upstream tracking
🔄 Stashing
Command	Description
    git stash	Save uncommitted changes for later
    git stash list	List stashed changes
    git stash apply	Reapply the latest stash
    git stash pop	Apply and remove the latest stash
    git stash drop	Delete a stash
❌ Undoing Changes
Command	Description
    git restore <file>	Restore a file to the last committed state
    git reset <file>	Unstage a file
    git reset --hard	Discard all changes and reset to last commit
    git revert <commit>	Create a new commit that undoes a commit
🧪 Tagging
Command	Description
    git tag	List tags
    git tag <name>	Create a tag
    git tag -a <name> -m "msg"	Create an annotated tag
    git push origin <tag>	Push a tag to the remote
🧱 Submodules
Command	Description
    git submodule add <url>	Add a submodule
    git submodule update --init	Initialize and fetch submodules
🧪 Git Aliases (optional)
Command	Description
    git config --global alias.co checkout	Create an alias like git co for git checkout
    git config --global alias.st status	Alias git st for git status
⚠️ Cleaning Up
Command	Description
    git clean -f	Remove untracked files
    git clean -fd	Remove untracked files and directories