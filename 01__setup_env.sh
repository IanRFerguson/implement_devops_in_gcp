### Setup instructions and Question 1 ###

# Pass in region and zone as command line arguments
export REGION=$1
export ZONE=$2
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')


# Authorize the shell instance
gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION


# These don't strictly matter for the challenge lab 
git config --global user.email hello@ian.edu
git config --global user.name ian


###


# Enable relevant APIs
gcloud services enable container.googleapis.com \
    cloudbuild.googleapis.com \
    sourcerepo.googleapis.com

# Add the Kubernetes Developer role to the active service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$(gcloud projects describe $PROJECT_ID  \
    --format="value(projectNumber)")@cloudbuild.gserviceaccount.com \
    --role="roles/container.developer"

# Create a cloud repo to link to git
gcloud artifacts repositories create my-repository \
    --repository-format=docker \
    --location=$REGION

# Create a Kubernetes cluster to work off of
gcloud container clusters create "hello-cluster" \
    --zone $ZONE \
    --no-enable-basic-auth \
    --cluster-version "1.27.3-gke.100" \
    --release-channel "regular" \
    --machine-type "e2-medium" \
    --image-type "COS_CONTAINERD" \
    --disk-type "pd-balanced" \
    --disk-size "100" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --max-pods-per-node "110" \
    --num-nodes "3" \
    --logging=SYSTEM,WORKLOAD \
    --monitoring=SYSTEM \
    --enable-ip-alias \
    --default-max-pods-per-node "110" \
    --enable-autoscaling \
    --min-nodes "2" \
    --max-nodes "6"\
    --no-enable-master-authorized-networks \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
    --enable-managed-prometheus \
    --enable-autoupgrade \
    --enable-autorepair \
    --max-surge-upgrade 1 \
    --max-unavailable-upgrade 0 \
    --node-locations $ZONE

# Create dev and prod namespaces
kubectl create namespace prod && kubectl create namespace dev