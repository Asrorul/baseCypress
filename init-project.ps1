# PowerShell script to initialize a new Cypress Cucumber TypeScript project

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# Create project directory
$projectPath = Join-Path (Get-Location) $ProjectName
New-Item -ItemType Directory -Path $projectPath

# Create directory structure
$directories = @(
    "cypress/e2e/features",
    "cypress/support/stepDefinitions",
    "cypress/support/commands",
    "cypress/pages",
    "reports"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path (Join-Path $projectPath $dir) -Force
}

# Copy template files
$templateFiles = @(
    "package.json",
    "tsconfig.json",
    "cypress.config.ts",
    "cypress.env.json",
    "README.md",
    "cypress/support/e2e.ts",
    "cypress/support/commands.ts",
    "cypress/e2e/features/example.feature",
    "cypress/support/stepDefinitions/example.ts"
)

foreach ($file in $templateFiles) {
    $sourcePath = Join-Path (Get-Location) $file
    $destPath = Join-Path $projectPath $file
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
    }
}

# Initialize git repository
Set-Location $projectPath
git init

# Create .gitignore
@"
node_modules/
reports/
cypress/videos/
cypress/screenshots/
.DS_Store
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Update package.json with new project name
$packageJson = Get-Content -Path "package.json" -Raw | ConvertFrom-Json
$packageJson.name = $ProjectName
$packageJson | ConvertTo-Json -Depth 100 | Set-Content "package.json"

# Install dependencies
npm install

Write-Host "Project $ProjectName has been created successfully!"
Write-Host "To get started:"
Write-Host "cd $ProjectName"
Write-Host "npm run test:cy"
