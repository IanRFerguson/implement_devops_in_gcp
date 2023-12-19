### Question 2 ###

# Create an emtpy repo in CSR
gcloud source repos create sample-app

# Clone the sample application
gcloud source repos clone sample-app \
    --project=$PROJECT_ID

# Copy template files from GCS to local repo
gsutil cp -r gs://spls/gsp330/sample-app/* ~/sample-app

# Iteratively update region and zone in the build files
for file in sample-app/cloudbuild-dev.yaml sample-app/cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done


###


# First commit to master
cd sample-app
git init
git add .
git commit -m "let's rock"
git push origin master

# First commit to dev
git checkout -b dev && git push origin dev