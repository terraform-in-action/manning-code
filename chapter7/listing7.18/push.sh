git init && git add -A && git commit -m "initial push"
git config --global credential.https://source.developers.google.com.helper gcloud.sh
git remote add google $1
gcloud auth login && git push --all google