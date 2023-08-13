# [1] Set the base image to use for the container
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
# Set the working directory inside the container
WORKDIR /app

# [2] Copy the project file and restore dependencies
# Copy the project file(s) to the container
COPY *.csproj ./
# Restore the NuGet packages
RUN dotnet restore

# [3] Copy the remaining source code and build the application
# Copy the application source code to the container
COPY . ./
# Build the application
RUN dotnet build --configuration Release --no-restore
# Publish the application
RUN dotnet publish --configuration Release --no-build --output /app/publish

# [4]] Build the runtime image
# Set the base image to use for the runtime container
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
# Set the working directory inside the container
WORKDIR /app
# Copy the published application from the build container
COPY --from=build /app/publish .
# Set the entry point for the container
ENTRYPOINT ["dotnet", "SampleAPI.dll"]