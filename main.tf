data "google_compute_network" "this" {
  name = var.network
}

locals {
  subnetwork_self_links = data.google_compute_network.this.subnetworks_self_links
}

data "google_compute_subnetwork" "this" {
  for_each  = toset(local.subnetwork_self_links)
  self_link = each.value
}

locals {
  subnetwork_list       = values(data.google_compute_subnetwork.this)
  subnetwork_cidr_list  = local.subnetwork_list[*].ip_cidr_range
  subnetwork_region_map = { for i, v in local.subnetwork_list : v.region => v if v.region != null }
}
