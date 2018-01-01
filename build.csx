#r "packages/SimpleExec.2.0.0/lib/netstandard1.3/SimpleExec.dll"

#load "packages/simple-targets-csx.6.0.0/contentFiles/csx/any/simple-targets.csx"

using System;
using static SimpleTargets;
using static SimpleExec.Command;

var targets = new TargetDictionary();

targets.Add("default", DependsOn("pack", "test"));

targets.Add(
    "build",
    () => Run(
        "dotnet",
        "build LiteGuard.sln /property:Configuration=Release /nologo /maxcpucount " +
            $"/fl /flp:LogFile=build.log;Verbosity=Detailed;PerformanceSummary " +
            $"/bl:build.binlog"));

targets.Add(
    "pack",
    DependsOn("build"),
    () =>
    {
        foreach (var nuspec in new[] { "LiteGuard.nuspec", "LiteGuard.Source.nuspec", })
        {
            Environment.SetEnvironmentVariable("NUSPEC_FILE", nuspec, EnvironmentVariableTarget.Process);
            Run("dotnet", $"pack src/LiteGuard --configuration Release --no-build");
        }
    });

targets.Add("test", DependsOn("build"), () => Run("dotnet", $"xunit -configuration Release -nobuild", "./tests/LiteGuardTests"));

Run(Args, targets);
