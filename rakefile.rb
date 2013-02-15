require 'albacore'
require 'fileutils'
require File.expand_path('rakehelper/rakehelper', File.dirname(__FILE__))

ENV["XunitConsole_net20"] = "packages/xunit.runners.1.9.1/tools/xunit.console.exe"
ENV["NuGetConsole"] = "packages/NuGet.CommandLine.2.2.0/tools/NuGet.exe"

Albacore.configure do |config|
  config.log_level = :verbose
end

desc "Executes clean, build, spec and nugetpack"
task :default => [ :clean, :build, :spec, :nugetpack ]

desc "Use Mono in Windows"
task :mono do
  ENV["Mono"] = "x"
  if ARGV.length == 1 && ARGV[0] = "mono"
    Rake::Task["default"].invoke
  end
end

desc "Clean solution"
task :clean do
  FileUtils.rmtree "bin"

  build = RakeHelper.use_mono ? XBuild.new : MSBuild.new
  build.properties = { :configuration => :Release }
  build.targets = [ :Clean ]
  build.solution = "src/LiteGuard.sln"
  build.execute
end

desc "Build solution"
task :build do
  build = RakeHelper.use_mono ? XBuild.new : MSBuild.new
  build.properties = { :configuration => :Release }
  build.targets = [ :Build ]
  build.solution = "src/LiteGuard.sln"
  build.execute
end

desc "Execute specs"
task :spec do
  specs = [
    { :version => :net20, :path => "src/test/LiteGuard.Specifications/bin/Debug/LiteGuard.Specifications.dll" },
  ]
  execute specs
end

desc "Create the nuget package"
nugetpack :nugetpack do |nuget|
  FileUtils.mkpath "bin"
  
  # NOTE (Adam): nuspec files can be consolidated after NuGet 2.3 is released - see http://nuget.codeplex.com/workitem/2767
  nuget.command = RakeHelper.nuget_command
  nuget.nuspec = [ "src/LiteGuard", ENV["OS"], "nuspec" ].select { |token| token }.join(".")  
  nuget.output = "bin"
end

def execute(tests)
  tests.each do |test|
    xunit = XUnitTestRunner.new
    xunit.command = RakeHelper.xunit_command(test[:version])
    xunit.assembly = test[:path]
    xunit.options "/html " + test[:path] + ".html"
    xunit.execute  
  end
end
