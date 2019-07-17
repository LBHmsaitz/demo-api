FROM microsoft/dotnet:2.2-sdk as builder

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY demo-api/ ./

# Copy everything else and build
RUN dotnet publish -c Release -o out 

# Use a smaller image
FROM microsoft/dotnet:2.2.0-aspnetcore-runtime-alpine

WORKDIR /app/
#Copy over the compiled application from the build image
COPY --from=builder /app/out .

EXPOSE ${PORT:-3000}
CMD ASPNETCORE_URLS=http://+:${PORT:-3000} dotnet ./demo-api.dll
