# Infrastructure as Code for Weightr Android App

This repository manages Firebase/Firestore infrastructure for the Weightr Android application using Terraform/OpenTofu.

### Prerequisites
- Create a new Google Cloud project and add Firebase.
- Enable Firestore in Native mode via the Firebase console (this Terraform config will create the `(default)` database).

### How to use
1. Create a `main.tfvars` file with your project details. Example:
```hcl
project_id  = "my-unique-weightr-app"
location_id = "nam5"
```

2. Authenticate to Google Cloud:
Follow the [Google provider authentication guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#authentication).

3. Initialize and apply:
```bash
tofu init
tofu plan -var-file=main.tfvars
tofu apply -var-file=main.tfvars
```

This configuration:
- Creates the default Firestore Native database in the specified location.
- Deploys Firestore security rules from `firestore.rules`.
- Creates a custom descending index on `__name__` in the `daily_weights` collection (required for DESC ordering, as default indexes only support ASC).
