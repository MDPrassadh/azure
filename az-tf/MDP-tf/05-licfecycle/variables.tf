variable "allowed_locations" {
  type    = list(string)
  default = ["eastus", "westus", "centralus"]
  description = "List of allowed locations for resource deployment."
}

