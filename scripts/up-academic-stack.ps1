param(
    [string]$EnvFile = ".env.example",
    [string]$ProjectName = "jhon-academic"
)

$ErrorActionPreference = "Stop"

Write-Host "1/4 Levantando PostgreSQL y RabbitMQ..."
docker compose -p $ProjectName --env-file $EnvFile --profile academic up -d postgres rabbitmq

Write-Host "2/4 Aplicando el esquema academic_management..."
docker compose -p $ProjectName --env-file $EnvFile --profile tooling run --rm liquibase-academic update

Write-Host "3/4 Construyendo y levantando academic-api..."
docker compose -p $ProjectName --env-file $EnvFile --profile academic up -d --build academic-api

Write-Host "4/4 Estado final"
docker compose -p $ProjectName --env-file $EnvFile --profile academic ps
Write-Host "Salud: http://localhost:8003/actuator/health"
