# How to build

These instructions are *only* for building with Rake, which includes compilation, test execution and packaging. This is the simplest way to build.

You can also build the solution using Visual Studio 2012 or later.

*Don't be put off by the prerequisites!* It only takes a few minutes to set them up and only needs to be done once. If you haven't used [Rake](http://rake.rubyforge.org/ "RAKE -- Ruby Make") before then you're in for a real treat!

At the time of writing the build is confirmed to work on:

* Windows + Microsoft .NET framework
* Windows + Mono
* Linux + Mono
* OSX + Mono

Note that under Mono, the PCL target is [redirected](https://github.com/liteguard/liteguard/blob/master/src/Microsoft.Portable.CSharp.targets) to build against .NET framework 4.0, due to lack of support for PCL in Mono at the time of writing. This means the PCL output in the NuGet package produced by a Mono build cannot be used :frowning:.

## Prerequisites

1. Install Ruby 1.8.7 or later.

 For Windows we recommend using [RubyInstaller](http://rubyinstaller.org/) and selecting 'Add Ruby executables to your PATH' when prompted. For alternatives see the [Ruby download page](http://www.ruby-lang.org/en/downloads/).
1. Using a command prompt, update RubyGems to the latest version*:

    `gem update --system`

1. Install/update Rake (already included in Ruby 1.9 or later)*:

    `gem install rake`
    
1. Install/update Albacore*:

    `gem install albacore`

1. If you are using Windows and you want to build using the Microsoft .NET framework, ensure you have versions 3.5 and either 4.0 or 4.5 installed.

1. If you are using Linux, install Mono 2.10.9 or later**:

    `sudo apt-get install mono-complete`

1. If you are using OSX, or if you want to use Mono in Windows, [install Mono 2.10.9 or later](http://www.go-mono.com/mono-downloads/)**.

## Building

Using a command prompt, navigate to your clone root folder and execute:

`rake`

This executes the default build tasks. After the build has completed, the build artifacts will be located in `bin`.

## Extras

* View the full list of build tasks:

    `rake -T`

* Run a specific task:

    `rake spec`

* Run multiple tasks:

    `rake spec pack`

* Run the default build using Mono in Windows (this has no effect in Linux or OSX which already uses Mono by default):

    `rake mono`

* Run specific or multiple tasks using Mono in Windows:

	`rake mono spec`
 
 or

	`rake mono spec pack`
	
* Run initial tasks using .NET and further tasks using Mono in Windows (barely useful but ultra cool):

    `rake clean build mono spec pack`

 (All tasks before `mono` will use .NET and all tasks after `mono` will use Mono.)

* View the full list of rake options:

    `rake -h`

*If you are using Linux or OSX, you may have to execute this command using `sudo`.

**Earlier versions of Mono may also work if Microsoft.Build.dll is manually added to the Mono GAC.
