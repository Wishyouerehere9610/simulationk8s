#shell string 切割
## plan A
#!/bin/bash
 
string="hello,shell,split,test"  
array=(${string//,/ })  
 
for var in ${array[@]}
do
   echo $var
done

# git resitry mirros
git clone ${project} ./TMP
git remote add gitea git@git.conti2021.org:libk/aiworks-py.git 
git branch -r | grep -v '\->' | while read remote; 
do 
	git branch --track "${remote#origin/}" "$remote"; 
	git push gitea "$remote";
done
cd ../ && rm -rf ./TMP


git remote add gitea http://gitea.local/Jack/aiworks-py.git
git push -u gite main


git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git fetch --all

git_registry_transfer "git@gitee.com" "git@github.com" "ContiCat/continote" 

#!/bin/bash

#Forge unified public key and private key
cat > /root/.ssh/id_rsa << EOF
-----BEGIN OPENSSH PRIVATE KEY-----
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
T6v4ocYsXmuFHjhQAAAAhyb290QGszMQE=
-----END OPENSSH PRIVATE KEY-----
EOF
chmod 600 /root/.ssh/id_rsa
cat > /root/.ssh/id_rsa.pub<< EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4PMm8OCekvbpMCNDOjOT61gyZ6zFJEaRDgjRr/W+5KpIeSE2xwXY4iVN5fOS6c0R1zQw2dC8z0ypfewza1pOb8+zQ0JpvHGIBEczM9DL/zNf5mBHGHGM5VMXuIwGjkTvfscpAPdsHZByeALXNke2PAErzaQLMQCQT38Y6sB2WClaDZbNnjKkljswX16fAUluXWJZQcIQnqSVU5QB1iHIrp0a9i3N1G0CCYbSRUBalHLHRsIgyNXJ9DxVyNfCQ/O/Dwyy85YcBruHnRNdV2cSSD2+QEFsPFJtx29qdlu0psNxM4e4tUbJrl5h8M57FFQwFb26lC7N+0g1wtua/M0MYJ5OcaD/KDG92Ci7ayd9c6xcZ6GHqxnTbxHbyMfvIunqqrSmt6vZNGL4DasTKtWs8HStWvneZHIY3NP4T3/e/hdMiKXZbGKDfqeIMMPuwEx8OOf3Vp4WTIrMJRth9tvAeSucw1I+qzj/HvBBv9dWZIiQ6hv42Vctvk3I5bJSC6XU= root@k31
EOF
chmod 644 /root/.ssh/id_rsa

SOURCE_REGISTRY=$1
SINK_REFISTRY=$2
REFISTRY_LIST=${@:3}

# Judgment parameters
if [ -n ${SOURCE_REGISTRY} ] && [ -n ${SINK_REFISTRY} ]; then
    # registry_transfer
    for REFISTRY in ${REFISTRY_LIST}
    do
    	echo ">> Start clone ${SOURCE_REGISTRY}:${REFISTRY}"
        git clone ${SOURCE_REGISTRY}.git ./TMP && cd ./TMP
        echo ">> Add remote ${SINK_REFISTRY}:${REFISTRY}"
        git remote add gitea ${SINK_REFISTRY}:${REFISTRY}.git
        git branch -r | grep -v '\->' | while read remote; 
        do  
        	echo ">> Migrating ${REFISTRY} ${remote}"
	        git branch --track "${remote#origin/}" "$remote"; 
	        git push gitea "$remote";
        done
        echo ">> Deleting temporary files"
        cd ../ && mv ./TMP /dev/null
	done
elif [ ! -n ${SOURCE_REGISTRY} ]; then
	echo "ERROR: Check source address"
elif [ ! -n ${SINK_REFISTRY} ]; then
	echo "ERROR: Check sink address"
else
	echo "ERROR: Check source and sink address"
fi