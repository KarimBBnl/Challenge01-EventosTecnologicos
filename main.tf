terraform {
  required_version = ">= 1.4.0"
}

locals {
  bucket_name      = "nexo-tech-karim-${substr(sha1(path.root), 0, 10)}"
  website_endpoint = "${local.bucket_name}.s3-website-us-east-1.amazonaws.com"
}

resource "terraform_data" "site_bootstrap" {
  input = local.bucket_name

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-NonInteractive", "-Command"]

    command = <<-POWERSHELL
      $ErrorActionPreference = "Continue"
      $bucket = "${local.bucket_name}"

      aws s3api head-bucket --bucket $bucket 2>$null
      $headBucketExitCode = $LASTEXITCODE
      if ($headBucketExitCode -ne 0) {
        aws s3api create-bucket --bucket $bucket --region us-east-1
      }

      $ErrorActionPreference = "Stop"

      aws s3api put-public-access-block --bucket $bucket --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
      aws s3api put-bucket-website --bucket $bucket --website-configuration 'IndexDocument={Suffix=index.html},ErrorDocument={Key=index.html}'

      $policyPath = Join-Path $env:TEMP ("nexo-tech-policy-" + $bucket + ".json")
      $policy = @{
        Version = "2012-10-17"
        Statement = @(@{
          Sid = "PublicReadGetObject"
          Effect = "Allow"
          Principal = "*"
          Action = "s3:GetObject"
          Resource = "arn:aws:s3:::${local.bucket_name}/*"
        })
      } | ConvertTo-Json -Depth 5
      $policy | Set-Content -Path $policyPath -Encoding ascii
      aws s3api put-bucket-policy --bucket $bucket --policy ("file://" + $policyPath)
      Remove-Item $policyPath -Force
    POWERSHELL
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-NoProfile", "-NonInteractive", "-Command"]

    command = <<-POWERSHELL
      $ErrorActionPreference = "Continue"
      aws s3 rb "s3://${self.input}" --force
    POWERSHELL
  }
}

resource "terraform_data" "site_content" {
  triggers_replace = [filesha256("${path.module}/index.html")]

  depends_on = [terraform_data.site_bootstrap]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-NonInteractive", "-Command"]

    command = <<-POWERSHELL
      $ErrorActionPreference = "Stop"
      aws s3 cp "${path.module}/index.html" "s3://${local.bucket_name}/index.html" --content-type "text/html; charset=utf-8"
      aws s3 cp "${path.module}/css" "s3://${local.bucket_name}/css" --recursive
      aws s3 cp "${path.module}/js" "s3://${local.bucket_name}/js" --recursive
    POWERSHELL
  }
}

output "bucket_name" {
  description = "Nombre del bucket S3 de la web estática."
  value       = local.bucket_name
}

output "website_endpoint" {
  description = "URL pública del hosting web de S3."
  value       = local.website_endpoint
}
