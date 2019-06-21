Get-ChildItem ".\*\terraform.tfstate" -ErrorAction SilentlyContinue -Recurse | ForEach-Object {
    $path = [io.path]::GetDirectoryName($_)
    Set-Location $path

    &terraform init

    &terraform destroy -auto-approve
}

Set-Location $PSScriptRoot
