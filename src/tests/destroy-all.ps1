Get-ChildItem ".\*\terraform.tfstate" -Recurse | ForEach-Object {
    $path = [io.path]::GetDirectoryName($_)
    Set-Location $path

    &terraform destroy -auto-approve
}

Set-Location $PSScriptRoot