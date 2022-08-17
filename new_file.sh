timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
# Creates the branch name
branch_name="bds-auto-save/${GITLAB_USER_EMAIL}/$timestamp"
# Opens the workspace directory
cd ${HOME}/workspace
# Obtains changes from git
git_status_response=$(git status --porcelain)
if [ -z "${git_status_response}" ]
then # No pending changes
    echo "- [INFO] - $(date +"%Y-%m-%d-%H-%M-%S") - There are NO pending changes."
else # There are pending changes
    if [ -f "${HOME}/workspace/.git/index.lock" ]
    then
        rm ${HOME}/workspace/.git/index.lock
    fi
    git checkout -b $branch_name
    git add --all
    git commit -m 'Auto save generated by BlackDiamond studio.'
    git push --force origin $branch_name
    curl http://localhost:3097/createAutoSave?branchName=${branch_name}"&"reportedTo=${GITLAB_USER_EMAIL} -H "Connection:close"
fi