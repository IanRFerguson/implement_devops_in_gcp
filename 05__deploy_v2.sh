### Question 5 ###
export DEV_CONTAINER__V2=$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v2.0 
export PROD_CONTAINER__V2=$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v2.0 


###


# Work off of the dev branch
git checkout dev

# Update the Go application per the instructions
# Build the v2.0 image
gcloud builds submit -t=$DEV_CONTAINER__V2 .


###


# Switch back to master
git checkout master

# Update the Go application
# Build the v2.0 image
gcloud builds submit -t=$PROD_CONTAINER__V2 .
