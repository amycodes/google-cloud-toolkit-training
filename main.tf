provider "google" {
  credentials = "${file("toolkit-robot.json")}"
}

module "vpc" {
    source = "github.com/terraform-google-modules/terraform-google-network"
    project_id   = "storefinder10"
    network_name = "example-vpc"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = true
            subnet_flow_logs      = true
        },
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]

        subnet-02 = []
    }
}
resource "google_folder" "it" {
  display_name = "Corporate IT"
  parent     = "organizations/674593799111"
}

resource "google_folder" "mkt" {
  display_name = "Marketing"
  parent     = "organizations/674593799111"
}

resource "google_folder" "ecom" {
  display_name = "E-Commerce"
  parent     = "organizations/674593799111"
}

resource "google_folder" "sec" {
  display_name = "Security"
  parent     = "organizations/674593799111"
}

resource "google_project" "ecom_storefinder" {
  name = "Store Finder"
  project_id = "storefinder10"
  folder_id  = "${google_folder.ecom.name}"
}
/*
module "storage-sink" {
  source           = "github.com/terraform-google-modules/terraform-google-log-export"
  name    = "test-project-sink-gcs"
  project = "storefinder10"
  filter  = "logName = /logs/cloudaudit.googleapis.com"

  storage = {
    name    = "${var.gcs_bucket_name}-project-sink"
    project = "${var.destination_project_id}"
  }
}
*/
