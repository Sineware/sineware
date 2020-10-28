# Creating Component Repos (and pulling branches or release tags)
All system-level components are pulled from our own downstream repositories. This way, when we want to update a partiular component, we can pull in changes from the upstream release, and they will be used the next time the build script is run. This also allows us to maintain custom patches on top of the upstream code.

## Creating a Repo and Setting the Upstream
Create an empty repository to house the downstream code. Then pull it:

`git clone https://github.com/Sineware/linux.git && cd linux`

Add the upstream repository:

`git remote add upstream git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git`

## Pulling Changes From Upstream

**Warning! The "master" branch of each downstream repository is pulled whenever the build script is run.**

Pull the upstream branch or release tag we want: (in this example, "linux-5.4.y")

`git pull upstream linux-5.4.y`

### Branch?
If the upstream is a branch, you can just push changes to the downstream repo master branch:

`git push origin master`

### Release Tag?
If the upstream is a release tag, you need to create a commit:

`git add .`

`git commit -m "Whatever release version"`

`git push origin master`

