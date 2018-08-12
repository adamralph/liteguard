// Copyright (c) 2013 Adam Ralph.

using System;
using System.Threading.Tasks;
using static Bullseye.Targets;
using static SimpleExec.Command;

internal class Program
{
    public static Task Main(string[] args)
    {
        Target("default", DependsOn("pack", "test"));

        Target("build", () => RunAsync("dotnet", "build LiteGuard.sln --configuration Release"));

        Target(
            "pack",
            DependsOn("build"),
            ForEach("LiteGuard.nuspec", "LiteGuard.Source.nuspec"),
            async nuspec =>
            {
                Environment.SetEnvironmentVariable("NUSPEC_FILE", nuspec, EnvironmentVariableTarget.Process);
                await RunAsync("dotnet", $"pack src/LiteGuard --configuration Release --no-build");
            });

        Target(
            "test",
            DependsOn("build"),
            () => RunAsync("dotnet", $"test ./tests/LiteGuardTests/LiteGuardTests.csproj --configuration Release --no-build"));

        return RunTargetsAsync(args);
    }
}
