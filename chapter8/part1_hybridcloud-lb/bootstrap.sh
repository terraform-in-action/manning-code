#!/bin/bash
# 1) create a project
PROJECT_ID=$1
gcloud projects create $PROJECT_ID

# 2) link billing account to project
BILLING_ACCOUNT=$(gcloud beta billing accounts list --filter open=true --uri | awk -F / '{print $NF}')
gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ACCOUNT

# 3) create service account
SERVICE_ACCOUNT_NAME=terraform
gcloud config set core/project $PROJECT_ID
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

# 4) grant IAM role to service account (usually Project Owner)
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com --role roles/owner

# 5) create and download access key for service account
gcloud iam service-accounts keys create account.json --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com

# 6) enable base services APIs
gcloud services enable cloudresourcemanager.googleapis.com serviceusage.googleapis.com