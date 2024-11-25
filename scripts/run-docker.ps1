# Name of the Docker image
$DOCKER_IMAGE = "mcr.microsoft.com/azuredataexplorer/kustainer-linux:latest"

Write-Host 'Checking if Docker container chris_adx_container is running...'
if (docker ps -q -f name=chris_adx_container) {
    Write-Host 'Docker container chris_adx_container is already running. Skipping start...'
} else {
    if (docker ps -a --format '{{.Names}}' | Select-String -Pattern '^chris_adx_container$$') {
        Write-Host 'A container named chris_adx_container already exists. Stopping and removing it...'
        docker stop chris_adx_container | Out-Null
        docker rm chris_adx_container | Out-Null
    }
    Write-Host "Running Docker container from image $DOCKER_IMAGE..."
    $startResult = docker run -d -p 8080:8080 --name chris_adx_container -e ACCEPT_EULA=Y $DOCKER_IMAGE
    if ($startResult) {
        Write-Host 'Docker container started successfully.'
        Start-Sleep -Seconds 5
    } else {
        Write-Host 'Failed to start Docker container' -ForegroundColor Red
        docker logs chris_adx_container
        exit 1
    }
}
$ErrorActionPreference = 'Stop'
$RET = 1
$COUNTER = 0
$MAX_TRIES = 10
while ($RET -ne 0 -and $COUNTER -lt $MAX_TRIES) {
    $COUNTER++
    Write-Host "Attempt ${COUNTER}/${MAX_TRIES}: Checking if the container is up..."
    try {
        $response = Invoke-RestMethod -Uri 'http://localhost:8080' -Method Get
        if ($response -match '<title>Azure Data Explorer</title>') {
            $RET = 0
        } else {
            Write-Host 'Container is not up yet. Retrying in 5 seconds...'
            Start-Sleep -Seconds 5
        }
    } catch {
        Write-Host 'Container is not up yet. Retrying in 5 seconds...'
        Start-Sleep -Seconds 5
    }
}
if ($RET -ne 0) {
    Write-Host "Failed to connect to the container after ${COUNTER} tries." -ForegroundColor Red
    exit 1
}
Write-Host 'Container is up and running!'

# Now show clusters
Invoke-RestMethod -Uri 'http://localhost:8080/v1/rest/mgmt' -Method Post -ContentType 'application/json' -Body '{"csl":".show cluster"}'