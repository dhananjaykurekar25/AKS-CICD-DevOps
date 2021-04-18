#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["AKS.Project.Sample/AKS.Project.Sample.csproj", "AKS.Project.Sample/"]
COPY ["AKS.Project.Sample.Tests/AKS.Project.Sample.Tests.csproj", "AKS.Project.Sample.Tests/"]
RUN dotnet restore "AKS.Project.Sample/AKS.Project.Sample.csproj"
RUN dotnet restore "AKS.Project.Sample.Tests/AKS.Project.Sample.Tests.csproj"
COPY . .
WORKDIR "/src/AKS.Project.Sample"
RUN dotnet build "AKS.Project.Sample.csproj" -c Release -o /app/build
WORKDIR "/src/AKS.Project.Sample.Tests"
RUN dotnet build "AKS.Project.Sample.Tests.csproj" -c Release -o /app/build

RUN dotnet test "AKS.Project.Sample.Tests.csproj" --logger "trx;LogFileName=UnitTestResults.trx"

FROM build AS publish
RUN dotnet publish "AKS.Project.Sample/AKS.Project.Sample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AKS.Project.Sample.dll"]