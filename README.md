# Deploy Legacy Java App GKE

## Description

### Detailed

The resources/services/activations/deletions that this app will create/trigger are:

- Compute
- IAM
- Service Networking
- Cloud SQL
- Google Kubernetes Engine

### PreDeploy

To deploy this blueprint you must have an active billing account and billing permissions.

## Documentation

- [Deploying a Java App using Kubernetes](https://cloud.google.com/architecture/application-development/java-app-gke)


## Requirements

These sections describe requirements for using this module.

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- roles/cloudsql.admin
- roles/file.editor
- roles/iam.serviceAccountUser
- roles/compute.admin
- roles/logging.admin
- roles/monitoring.admin
- roles/resourcemanager.projectIamAdmin
- roles/secretmanager.admin
- roles/iam.serviceAccountAdmin
- roles/servicenetworking.networksAdmin
- roles/storage.admin
- roles/serviceusage.serviceUsageAdmin
- roles/storage.hmacKeyAdmin

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- compute.googleapis.com
- sourcerepo.googleapis.com
- cloudbuild.googleapis.com
- storage.googleapis.com
- iam.googleapis.com
- cloudresourcemanager.googleapis.com
- container.googleapis.com
- file.googleapis.com
- servicenetworking.googleapis.com
- sqladmin.googleapis.com
- monitoring.googleapis.com

## Contributing

Refer to the [contribution guidelines](CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures


