# To run specific test:
# .\apply-tests.ps1 -f .\cw_log\test.tf

# To keep resources:
# .\apply-tests.ps1 -f .\cw_log\test.tf -k

# To run all tests:
# .\apply-tests.ps1

param(
    [switch][Alias("k")]$keepResources,
    [string][Alias("f")]$testFile,
    [switch][Alias("d")]$dry
)

function Test() {
    param([string]$testPath)
    Write-Host "Testing: $($testPath)" -ForegroundColor Cyan

    $path = [io.path]::GetDirectoryName($testPath)
    Set-Location $path

    &terraform init | Select-String -Pattern "Terraform has been successfully initialized!"

    if ($dry) {
        &terraform plan | Select-String -Pattern "Plan:"
    }
    else {
        &terraform apply -auto-approve | Select-String -Pattern "Apply complete!"
    }

    if (!$dry -and !$keepResources) {
        &terraform destroy -auto-approve | Select-String -Pattern "Destroy complete!"
    }
}

if ($testFile) {
    Test $testFile
}
else {
    Get-ChildItem ".\*\test.tf" -ErrorAction SilentlyContinue -Recurse | ForEach-Object {
        Test $_
    }
}

Set-Location $PSScriptRoot
