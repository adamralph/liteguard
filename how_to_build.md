# How to build

These instructions are *only* for building with Rake, which includes compilation, test execution and packaging. This is the simplest way to build.
It also replicates the build on the Continuous Integration build server and is the best indicator of whether a pull request will build.

*Don't be put off by the prerequisites!* It only takes a few minutes to set them up and only needs to be done once. If you haven't used [Rake](http://rake.rubyforge.org/ "RAKE -- Ruby Make") before then you're in for a real treat!

You can also build the solution using Visual Studio 2015 or later, but this doesn't provide the same assurances as the Rake build.

Note that under Mono, the PCL target is [redirected](https://github.com/liteguard/liteguard/blob/master/src/Microsoft.Portable.CSharp.targets) to build against .NET framework 4.0, due to lack of support for PCL in Mono at the time of writing. This means the PCL output in the NuGet package produced by a Mono build cannot be used :frowning:.

## Prerequisites

1. If you are using Windows and you want to build using the Microsoft .NET framework:

  1. Ensure you have .NET framework 3.5 and 4.0 or later installed.

  1. Ensure you have Visual Studio 2012 or later or MSBuild 4.5 or later installed.

1. If you are using Linux, install Mono 2.10.9 or later:<sup>1</sup>

    `sudo apt-get install mono-complete`

1. If you are using OSX, or if you want to use Mono in Windows, [install Mono 2.10.9 or later](http://www.go-mono.com/mono-downloads/).<sup>1</sup>

1. Install Ruby 1.8.7 or later.

 For Windows we recommend using the [RubyInstaller](http://rubyinstaller.org/) and selecting 'Add Ruby executables to your PATH' when prompted. For alternatives see the [Ruby download page](http://www.ruby-lang.org/en/downloads/).

1. Using a command prompt, update RubyGems to the latest version:<sup>2</sup>

    `gem update --system`

1. Install bundler:<sup>2</sup>

    `gem install bundler`

1. Install gems:<sup>2</sup>

    `bundler install`

## Building

Using a command prompt, navigate to your clone root folder and execute:

`bundle exec rake`

This executes the default build tasks. After the build has completed, the build artifacts will be located in `artifacts`.

## Extras

* View the full list of build tasks:

    `bundle exec rake -T`

* Run a specific task:

    `bundle exec rake accept`

* Run multiple tasks:

    `bundle exec rake accept pack`

* Run the default build using Mono in Windows (this has no effect in Linux or OSX which already uses Mono by default):

    `bundle exec rake mono`

* Run specific or multiple tasks using Mono in Windows:

    `bundle exec rake mono spec`

 or

    `bundle exec rake mono spec pack`

* Run initial tasks using .NET and further tasks using Mono in Windows (barely useful but ultra cool):

    `bundle exec rake clean build mono spec pack`

 (All tasks before `mono` will use .NET and all tasks after `mono` will use Mono.)

* View the full list of rake options:

    `bundle exec rake -h`

<sup>1 Earlier versions of Mono may also work if Microsoft.Build.dll is manually added to the Mono GAC.</sup>

<sup>2 If you are using Linux or OSX, you may have to execute this command using `sudo`.</sup>
