<img src="https://raw.github.com/adamralph/liteguard/master/assets/liteguard_256.png" width="128" />

[![NuGet version](https://img.shields.io/nuget/v/LiteGuard.Source.svg?style=flat)](https://www.nuget.org/packages/LiteGuard.Source)
[![NuGet version](https://img.shields.io/nuget/v/LiteGuard.svg?style=flat)](https://www.nuget.org/packages/LiteGuard)
[![Build status](https://ci.appveyor.com/api/projects/status/dfxb7jtpp7ldu0b5/branch/master?svg=true)](https://ci.appveyor.com/project/adamralph/liteguard/branch/master)

Why, it's lighter than air!

The guard clause library which stands out from the crowd like the faintest passing whisper.

You'll hardly know it's there!

Get it from [NuGet](https://nuget.org/packages?q=liteguard "LiteGuard on NuGet") or [build from source](#build-from-source).

## Usage

```C#
public void Foo(Bar bar)
{
    Guard.AgainstNullArgument(nameof(bar), bar);
    Guard.AgainstNullArgumentProperty(nameof(bar), nameof(bar.Baz), bar.Baz);
    Guard.AgainstNullArgumentProperty(nameof(bar), "Baz.Bazz", bar.Baz.Bazz);

    // the rest of your method, nice and safe, wrapped in the protecting arms of LiteGuard
}

public void Foo<T>(T bar) where T : class
{
    Guard.AgainstNullArgument(nameof(bar), bar);
    ...
}

public void Foo<T>(T bar)
{
    Guard.AgainstNullArgumentIfNullable(nameof(bar), bar);
    ...
}
```

## Why did I create it?

The aim of LiteGuard is to be the most simple, unambiguous and lightweight guard clause library available.

### A very explicit DSL

The names of LiteGuard clauses are unambiguous to ensure correct usage. Misuse should be obvious.

```C#
public void Foo(Bar bar)
{
    var baz = GetBaz();
    Guard.AgainstNullArgument("baz", baz); // clearly incorrect - baz is not an argument
}
```

### No fluent API

Some guard clause libraries provide a fluent API.

A fluent API requires the creation of objects which serve no purpose other than to provide an access point for the next method in the DSL. The creation of these objects decreases performance, increases memory usage and adds pressure to the garbage collector. It is my belief that a guard clause library has no business in doing this. It should use as few resources as possible and be eligible for use in as wide a set of applications as possible. I love a good fluent API but it has its places and a guard clause library is not one of them.

### No business rule clauses

Many guard clause libraries provide a huge range of methods for determining whether arguments satisfy all manner of business rules.

In my opinion, it is not the job of a guard clause library to validate arguments against business rules. I believe the role of a guard clause library is to prevent method calls with null arguments or null argument values. Ideally, I'd like such things to be built into .NET languages. If that ever happens I will happily allow LiteGuard to retire gracefully to a small but comfortable home near the seaside with a carriage clock and a little Havanese.

## Build from source

Clone this repo, navigate to your clone folder and execute `build.cmd`. The only prerequisite you need is MSBuild 14, which is also included in Visual Studio 2015.

`build.cmd` executes the default build targets which include compilation, test execution and packaging. After the build has completed, the build artifacts will be located in `artifacts/output/`.

For full usage details for `build.cmd`, execute `build.cmd -?`. See  [simple-targets-csx](https://github.com/adamralph/simple-targets-csx) for more info.

You can also build the solution using Visual Studio 2015 or later. At the time of writing the build is only confirmed to work on Windows.

## Can I help to improve it and/or fix bugs?

Absolutely! Please feel free to raise issues, fork the source code, send pull requests, etc.

No pull request is too small. Even whitespace fixes are appreciated.

-
LiteGuard logo designed by [Vanja Pakaski](https://github.com/vanpak).
