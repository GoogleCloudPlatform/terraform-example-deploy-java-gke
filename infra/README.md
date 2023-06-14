# Deploy Legacy Java App GKE

Blueprint and sample to deploy Java web application onto GKE

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The name of the cluster (required) | `string` | `"xwiki"` | no |
| image | Xwiki docker image | `string` | `"gcr.io/migrate-legacy-java-app-gke/hsa-xwiki:latest"` | no |
| labels | A map of key/value label pairs to assign to the resources. | `map(string)` | <pre>{<br>  "app": "terraform-example-deploy-java-gke"<br>}</pre> | no |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | google cloud region where the resource will be created. | `string` | `"us-central1"` | no |
| zones | List of zones are deployment areas within a region. | `list(string)` | <pre>[<br>  "us-central1-a",<br>  "us-central1-b"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| db\_ip | The IPv4 address assigned for the master instance |
| jgroup\_bucket\_name | The bucket name for jgroup |
| neos\_walkthrough\_url | Neos Tutorial URL |
| nfs\_ip | Filestore IP address |
| xwiki\_ip | The public IP address of the XWiki application |
| xwiki\_url | The public URL of the XWiki application |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
