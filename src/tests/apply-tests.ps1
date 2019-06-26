# To run specific test:
# .\apply-tests.ps1 -f .\cw_log\test.tf

# To keep resources:
# .\apply-tests.ps1 -f .\cw_log\test.tf -k

# To run all tests:
# .\apply-tests.ps1

param(
    [switch][Alias("k")]$keepResources,
    [string][Alias("f")]$testFile,
    [switch][Alias("d")]$dry,
    [switch][Alias("v")]$verbose
)

function Test() {
    param([string]$testPath)
    Write-Host "Testing: $($testPath)" -ForegroundColor Cyan

    $path = [io.path]::GetDirectoryName($testPath)
    Set-Location $path

    &terraform init | Where-Object { $verbose -or $_ -match "Terraform has been successfully initialized!" }

    if ($dry) {
        &terraform plan | Where-Object { $verbose -or $_ -match "Plan:" }
    }
    else {
        &terraform apply -auto-approve | Where-Object { $verbose -or $_ -match "Apply complete!" }
    }

    if (!$dry -and !$keepResources) {
        &terraform destroy -auto-approve | Where-Object { $verbose -or $_ -match "Destroy complete!" }
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
