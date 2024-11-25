param (
    [string]$csvFilePath = "./data/StormEvents.csv"
)

# Variables
$resourceGroupName = "ChrisADXResourceGroup"
$clusterName = "ChrisADXTestbedCluster"  # replace with your actual cluster name
$databaseName = "ChrisADXTesbedDB"
$tableName = "StormEvents"  # replace with your actual table name

if (-not (Test-Path $csvFilePath)) {
    Write-Error "CSV file not found at the provided path: $csvFilePath"
    exit 1
}

Write-Host "filepath configured: $csvFilePath"

# Check if Resource Group exists
Write-Host "Checking if the resource group '$resourceGroupName' exists..."
$resourceGroupExists = az group exists --name $resourceGroupName

if ($resourceGroupExists -eq "false") {
    Write-Host "Resource group '$resourceGroupName' does not exist. Please create the resource group first." -ForegroundColor Red
    exit 1
}

Write-Host "Resource group '$resourceGroupName' exists."

# Check if Database exists
Write-Host "Checking if the database '$databaseName' exists in resource group '$resourceGroupName'..."
try {
    $databaseCheck = az kusto database show --resource-group $resourceGroupName --cluster-name $clusterName --name $databaseName
} catch {
    Write-Error "An error occurred while checking the database: $_"
    exit 1
}

if (!($databaseCheck)) {
    Write-Host "Database '$databaseName' does not exist in resource group '$resourceGroupName'. Please create the database first." -ForegroundColor Red
    exit 1
}

Write-Host "Database '$databaseName' exists in resource group '$resourceGroupName'."

# Ingest CSV file into the ADX database
Write-Host "Ingesting CSV file '$csvFilePath' into database '$databaseName'..."
try {
    az kusto blob ingest --cluster-name $clusterName --database-name $databaseName --table-name $tableName --file-path $csvFilePath --resource-group $resourceGroupName
    Write-Output "File uploaded successfully."
} catch {
    Write-Error "Failed to upload the file: $_"
    exit 1
}