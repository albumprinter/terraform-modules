# To run specific test:
# .\run-unit-tests.ps1 -f _resources\sqs\sqs_with_dlq\test.tf

# To keep resources:
# .\run-unit-tests.ps1 -f _resources\sqs\sqs_with_dlq\test.tf -k

# To run all tests:
# .\run-unit-tests.ps1

param(
    [switch][Alias("k")]$keepResources,
    [string][Alias("f")]$testFile,
    [switch][Alias("d")]$dry
)

function Test() {
    param([string]$testPath)

    $path = [io.path]::GetDirectoryName($testPath)
    Set-Location $path

    &terraform init

    if ($dry) {
        &terraform plan
    }
    else {
        &terraform apply -auto-approve
    }

    if (!$dry -and !$keepResources) {
        &terraform destroy -auto-approve
    }
}

if ($testFile) {
    Test $testFile
}
else {
    Get-ChildItem ".\*\test.tf" -Recurse | ForEach-Object {
        Test $_
    }
}

Set-Location $PSScriptRoot
