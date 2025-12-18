# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/WebApp/*.csproj ./WebApp/
RUN dotnet restore WebApp/WebApp.csproj

COPY src/ ./ 
WORKDIR /src/WebApp
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080
ENTRYPOINT ["dotnet", "WebApp.dll"]
