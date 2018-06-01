@echo Off
cd %~dp0

dotnet run --project targets -- %*
