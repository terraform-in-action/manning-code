git init
git add -A
git commit -m "init"
git config --global credential.https://source.developers.google.com.helper gcloud.sh
git remote add google https://source.developers.google.com/p/terraform-in-action2/r/chapter5-repo
gcloud auth login
git push --all google