provider "google" {
  credentials = file("../creds/serviceaccount.json")
  project     = "involuted-disk-277619"
  region      = "us-west2"
}
