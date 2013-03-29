#How to build#

These instructions are *only* for building with Rake, which includes compilation, test execution and packaging. Once you have the prerequisites set up this is the simplest way of building the assemblies.

You can also build the solution using Visual Studio 2012.

## Prerequisites ##

1. [Install Ruby 1.8.7 or later](http://www.ruby-lang.org/en/downloads/)
1. Using a command prompt, update RubyGems to the latest version*:

    `gem update --system`

1. Install Rake (if using Ruby 1.8.7)*:

    `gem install rake`
    
1. Install the Albacore gem*:

    `gem install albacore`

1. If you are using Linux, install Mono:

    `sudo apt-get install mono-complete`

1. If you are using OSX, or if you want to build using Mono in Windows, [install Mono 2.10.9 or later](http://www.go-mono.com/mono-downloads/)**.

1. If you are using Linux or OSX, you may have to grant yourself execute permissions on the bash scripts by navigating to your clone root folder and executing:

    `chmod 744 rakehelper/*.sh`

 You will also need to change your Git configuration to ignore file mode changes by navigating to your clone root folder and executing:

    `git config core.filemode false`

*If you are using Linux or OSX, you may have to execute this command using `sudo`

**Earlier versions of Mono may also work if Microsoft.Build.dll is manually added to the Mono GAC.

## Building ##

Using a command prompt, navigate to your clone root folder and execute:

`rake`

This executes the default build tasks. After the build has completed, the build artifacts will be located in `bin`.

##Extras##

* View the full list of build tasks:

    `rake -T`

* Run a specific task:

    `rake spec`

* Run multiple tasks:

    `rake spec nugetpack`

* Run the default build using Mono in Windows (this has no effect in Linux or OSX which already use Mono by default):

    `rake mono`

* Run specific or multiple tasks using Mono in Windows:

	`rake mono spec`
 
 or

	`rake mono spec nugetpack`
	
* Run initial tasks using .NET and further tasks using Mono in Windows (barely useful but ultra cool):

    `rake clean build mono spec nugetpack`

 (All tasks before `mono` will use .NET and all tasks after `mono` will use Mono.)
