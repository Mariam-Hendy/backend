	# Use the official .NET SDK image
# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Create the /src directory (this is usually not necessary but can help avoid errors)
RUN mkdir -p /src

# Copy the .csproj file to the current working directory
COPY HelloWorldApi.csproj . 

# Restore dependencies
RUN dotnet restore "HelloWorldApi.csproj"

# Copy the rest of the project files
COPY . .

# Build the application
RUN dotnet build "HelloWorldApi.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "HelloWorldApi.csproj" -c Release -o /app/publish

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish . 
ENTRYPOINT ["dotnet", "HelloWorldApi.dll"]

