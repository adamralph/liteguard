<img src="https://raw.github.com/adamralph/liteguard/main/assets/liteguard_256.png" width="128" />

# LiteGuard

_[![LiteGuard NuGet version](https://img.shields.io/nuget/v/LiteGuard.svg?style=flat&label=nuget%3A%20LiteGuard)](https://www.nuget.org/packages/LiteGuard)_
_[![LiteGuard.Source NuGet version](https://img.shields.io/nuget/v/LiteGuard.Source.svg?style=flat&label=nuget%3A%20LiteGuard.Source)](https://www.nuget.org/packages/LiteGuard.Source)_

_[![Build status](https://github.com/adamralph/liteguard/workflows/.github/workflows/ci.yml/badge.svg)](https://github.com/adamralph/liteguard/actions)_
_[![CodeQL analysis](https://github.com/adamralph/liteguard/workflows/.github/workflows/codeql-analysis.yml/badge.svg)](https://github.com/adamralph/liteguard/actions?query=workflow%3A.github%2Fworkflows%2Fcodeql-analysis.yml)_
_[![Lint](https://github.com/adamralph/liteguard/workflows/.github/workflows/lint.yml/badge.svg)](https://github.com/adamralph/liteguard/actions?query=workflow%3A.github%2Fworkflows%2Flint.yml)_
_[![Spell check](https://github.com/adamralph/liteguard/workflows/.github/workflows/spell-check.yml/badge.svg)](https://github.com/adamralph/liteguard/actions?query=workflow%3A.github%2Fworkflows%2Fspell-check.yml)_

Why, it's lighter than air!

The guard clause library which stands out from the crowd like the faintest passing whisper.

You'll hardly know it's there!

LiteGuard is a .NET package available as [source](https://www.nuget.org/packages/LiteGuard.Source) or [binary](https://www.nuget.org/packages/LiteGuard) for writing guard clauses. If your project is an application or library which is not packaged and/or exported for use in other solutions then the binary package is usually the best choice. If you are writing a library which is packaged and/or exported for use in other solutions then the source code package is usually the best choice.

Platform support: [.NET Standard 1.0 and upwards](https://docs.microsoft.com/en-us/dotnet/standard/net-standard).

We all have to do our bit in working toward the ultimate number of published guard clause libraries which, at current estimates, is somewhere in the region of 6.02214129(27) × 10^23.

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
