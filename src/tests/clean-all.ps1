Get-ChildItem -Filter ".terraform" -ErrorAction SilentlyContinue -Recurse | ForEach-Object {
    $path = [io.path]::GetDirectoryName($_.FullName)
    Set-Location $path
    Write-Output "Cleaning $($path)"

    &terraform init

    $Env:TF_WARN_OUTPUT_ERRORS = 0
    &terraform destroy -auto-approve
}

Set-Location $PSScriptRoot
