// Copyright (c) 2013 Adam Ralph.

using System;
using System.Threading.Tasks;
using static Bullseye.Targets;
using static SimpleExec.Command;

internal class Program
{
    public static Task<int> Main(string[] args)
    {
        Add("default", DependsOn("pack", "test"));

        Add("build", () => RunAsync("dotnet", "build LiteGuard.sln --configuration Release"));

        Add(
            "pack",
            DependsOn("build"),
            async () =>
            {
                foreach (var nuspec in new[] { "LiteGuard.nuspec", "LiteGuard.Source.nuspec", })
                {
                    Environment.SetEnvironmentVariable("NUSPEC_FILE", nuspec, EnvironmentVariableTarget.Process);
                    await RunAsync("dotnet", $"pack src/LiteGuard --configuration Release --no-build");
                }
            });

        Add(
            "test",
            DependsOn("build"),
            () => RunAsync("dotnet", $"test ./tests/LiteGuardTests/LiteGuardTests.csproj --configuration Release --no-build"));

        return RunAsync(args);
    }
}
