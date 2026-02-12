terraform {
  required_version = ">= 1.0"

  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
    }
  }
}

# Use with .tfvars
variable "project_id" {
  type        = string
  description = "Weightr's Firebase project ID"
}

variable "location_id" {
  type    = string
  default = "nam5"
}

provider "google-beta" {
  project = var.project_id
}

resource "google_firestore_database" "default" {
  provider = google-beta

  project     = var.project_id
  name        = "(default)"
  location_id = var.location_id
  type        = "FIRESTORE_NATIVE"
}

resource "google_firebaserules_ruleset" "firestore_rules" {
  project = var.project_id
  source {
    files {
      name    = "firestore.rules"
      content = file("${path.module}/firestore.rules")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_firebaserules_release" "firestore_release" {
  provider = google-beta

  project      = var.project_id
  name         = "cloud.firestore"
  ruleset_name = google_firebaserules_ruleset.firestore_rules.name

  depends_on = [
    google_firestore_database.default
  ]
}

# This index is needed since default index supports only ASC sorting
resource "google_firestore_index" "daily_weights_by_date_desc" {
  project    = var.project_id
  collection = "daily_weights"

  fields {
    field_path = "__name__"   # Internal field for document ID
    order      = "DESCENDING"
  }

  depends_on = [google_firestore_database.default]
}
