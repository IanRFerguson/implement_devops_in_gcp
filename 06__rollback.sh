### Question 6 ###

# Make sure your prod deployment is running on v2.0
kubectl get deployments -n prod -o wide 

# Rollback to v1.0
kubectl -n prod rollout undo deployment/production-deployment

# Check the deployment metadata again, we should see image v1.0 
kubectl get deployments -n prod -o wide