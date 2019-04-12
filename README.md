<img src="https://raw.github.com/adamralph/liteguard/master/assets/liteguard_256.png" width="128" />

# LiteGuard

_[![LiteGuard NuGet version](https://img.shields.io/nuget/dt/LiteGuard.svg?style=flat&label=nuget%3A%20LiteGuard)](https://www.nuget.org/packages/LiteGuard)_
_[![LiteGuard.Source NuGet version](https://img.shields.io/nuget/dt/LiteGuard.Source.svg?style=flat&label=nuget%3A%20LiteGuard.Source)](https://www.nuget.org/packages/LiteGuard.Source)_
_[![Appveyor build status](https://ci.appveyor.com/api/projects/status/dfxb7jtpp7ldu0b5/branch/master?svg=true)](https://ci.appveyor.com/project/adamralph/liteguard/branch/master)_
_[![Travis CI build status](https://img.shields.io/travis/adamralph/liteguard/master.svg?logo=travis)](https://travis-ci.org/adamralph/liteguard/branches)_

Why, it's lighter than air!

The guard clause library which stands out from the crowd like the faintest passing whisper.

You'll hardly know it's there!

LiteGuard is a .NET package available as [source](https://www.nuget.org/packages/LiteGuard.Source) or [binary](https://www.nuget.org/packages/LiteGuard) for writing guard clauses.

Platform support: [.NET Standard 1.0 and upwards](https://docs.microsoft.com/en-us/dotnet/standard/net-standard).

## Quick start

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

---

<sub>LiteGuard logo designed by [Vanja Pakaski](https://github.com/vanpak).</sub>
