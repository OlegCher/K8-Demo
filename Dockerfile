#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["K8-Demo/K8-Demo.csproj", "K8-Demo/"]
RUN dotnet restore "K8-Demo/K8-Demo.csproj"
COPY . .
WORKDIR "/src/K8-Demo"
RUN dotnet build "K8-Demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "K8-Demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "K8-Demo.dll"]