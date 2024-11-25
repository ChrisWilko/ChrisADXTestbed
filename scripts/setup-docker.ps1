# Name of the Docker image
$DOCKER_IMAGE = "mcr.microsoft.com/azuredataexplorer/kustainer-linux:latest"

Write-Host 'Checking if Docker is running...'
try {
    docker info | Out-Null
    Write-Host 'Docker is running...'
}
catch {
    Write-Host 'Docker is not running. Please start Docker.' -ForegroundColor Red
    exit 1
}
Write-Host "Checking if Docker image $DOCKER_IMAGE is downloaded..."
if (-Not (docker images -q $DOCKER_IMAGE)) {
    Write-Host "Docker image $DOCKER_IMAGE not found. Downloading..."
    docker pull $DOCKER_IMAGE
}
Write-Host 'Docker is downloaded and setup'