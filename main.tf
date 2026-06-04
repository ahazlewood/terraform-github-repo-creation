terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
    #token = "${{ secrets.REPO_TOKEN }}" ##GitHub Actions secret 
    token = var.repo_token ##Local env variable testnig"
}

resource "github_repository" "new_repo" {
  name        = var.repo_name
  description = "New terraform repo"

  visibility = "public"

}