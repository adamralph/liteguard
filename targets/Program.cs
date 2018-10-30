using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using static Bullseye.Targets;
using static SimpleExec.Command;

internal class Program
{
    public static Task Main(string[] args)
    {
        var testFrameworks = new List<string> { "netcoreapp2.1" };
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            testFrameworks.Add("netcoreapp1.1");
        }

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
            testFrameworks,
            framework => RunAsync("dotnet", $"test ./tests/LiteGuardTests/LiteGuardTests.csproj --configuration Release --no-build --framework {framework}"));

        return RunTargetsAsync(args);
    }
}
