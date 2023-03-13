# Deploy Legacy Java App GKE

Blueprint and sample to deploy Java web application onto GKE

### E2E test
#### Create new project
```
gcloud config set project ${PROJECT_ID}
cd tools/
./prepare_cloudbuild_e2e.sh
cd ../
gcloud builds submit .
```

### Test cleanup
```
gcloud builds submit . --config=./cloudbuild_destroy.yaml
```


