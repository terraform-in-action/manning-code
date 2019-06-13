# create project
export PROJECT_ID=terraform-in-action
export SERVICE_ACCOUNT=terraform
gcloud beta billing accounts list
export BILLING_ACCOUNT=
#i.e. gcloud projects create <PROJECT_ID>


#put all this in a null resource
gcloud projects create $PROJECT_ID

gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ACCOUNT

# gcloud project set to current
#i.e. gcloud project set core/project <PROJECT_ID>
gcloud config set core/project $PROJECT_ID

#create service account
gcloud iam service-accounts create $SERVICE_ACCOUNT

#create access key
gcloud iam service-accounts keys create account.json --iam-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com

#set permissions for service account
gcloud projects add-iam-policy-binding terraform-in-action --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com --role roles/owner

#enable service usage API
gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com