Set-Location $PSScriptRoot
docker buildx rm mybuilder
docker buildx create --use --name mybuilder 
#docker buildx ls
#docker buildx inspect --bootstrap
docker buildx build --platform=linux/arm64,linux/amd64 -f dockerfile -t drjp81/sonarr:latest --push --progress=plain .
