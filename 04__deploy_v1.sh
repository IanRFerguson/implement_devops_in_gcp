### Question 4 ###
export DEV_CONTAINER__V1=$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0 
export PROD_CONTAINER__V1=$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0 


###


# Build dev container
gcloud builds submit --tag=$DEV_CONTAINER__V1 .


# Wait for the build to finish...
# Expose the dev deployment to port 8080
kubectl expose deployment development-deployment \
    -n dev \
    --name=dev-deployment-service \
    --type=LoadBalancer \
    --port 8080 \
    --target-port 8080


###


gcloud builds submit --tag=$PROD_CONTAINER__V1


# Wait for the build to finish...
# Expose the prod deployment to port 8080
kubectl expose deployment production-deployment \
    -n prod \
    --name=prod-deployment-service \
    --type=LoadBalancer \
    --port 8080 \
    --target-port 8080