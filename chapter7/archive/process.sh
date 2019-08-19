# 1) create a project
export PROJECT_ID=terraform-in-action
gcloud projects create $PROJECT_ID

# 2) link billing account
gcloud beta billing accounts list
export BILLING_ACCOUNT=
gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ACCOUNT

# 3) create service account
export SERVICE_ACCOUNT=terraform
gcloud config set core/project $PROJECT_ID
gcloud iam service-accounts create $SERVICE_ACCOUNT

# 4) grant IAM role to service account (usually Project Owner)
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com --role roles/owner

# 5) create access key
gcloud iam service-accounts keys create account.json --iam-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com

# 6) enable service usage API
gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com