#How to build#

**NOTE:** These instructions are *only* for building with Rake, which includes compilation, test execution and packaging. You can also build the solution in Visual Studio 2012.

## Prerequisites ##

1. [Install Ruby 1.8.7 or later](http://www.ruby-lang.org/en/downloads/)
1. Using a command prompt, update RubyGems to the latest version: 

    `gem update --system`

1. Install the albacore gem:

    `gem install albacore`

 or if you have already installed albacore, please update to the latest version:

    `gem update albacore`

1. If you are using Linux, install Mono:

    `sudo apt-get install mono-complete`

1. If you are using OSX, or if you want to build using Mono in Windows, [install Mono 2.10.9 or later](http://www.go-mono.com/mono-downloads/)*.

1. If you are using Linux or OSX, you may have to grant yourself execute permissions on the shell script files under src/rakehelper (assuming you are in the src folder):

    `chmod 744 rakehelper/*.sh`

 You may also need to change your Git configuration to ignore the file mode changes:

    `git config core.filemode false`

## Building ##

1. Using a command prompt, navigate to the src folder (which contains rakefile.rb)
1. Run the default build (compile, test and package) by typing the following command:

    `rake`

After the build has completed, there will be a new folder in the src folder called "bin" containing the build artifacts.

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
	
* Run initial tasks using .NET and further tasks using Mono in Windows (barely useful but ultra cool)

    rake clean build mono spec feature nugetpack

 (All tasks before `mono` will use .NET and all tasks after `mono` will use Mono.)

*** Earlier versions of Mono may also work if Microsoft.Build.dll is manually added to the Mono GAC.