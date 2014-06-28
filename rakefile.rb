require 'albacore'
require 'fileutils'

@version = IO.read("src/CommonAssemblyInfo.cs").split(/AssemblyInformationalVersion\("/, 2)[1].split(/"/).first
net20 = "2.0.50727"
net40 = "4.0.30319"
xunit_console_net20 = { :command => "src/packages/xunit.runners.1.9.2/tools/xunit.console.exe", :net_version => net20 }
xunit_console_net40 = { :command => "src/packages/xunit.runners.1.9.2/tools/xunit.console.clr4.exe", :net_version => net40 }
nuget_console = { :command => "src/packages/NuGet.CommandLine.2.8.2/tools/NuGet.exe", :net_version => net40 }
solution = "src/LiteGuard.sln"
output = "bin"

specs = [
  { :console => xunit_console_net20, :assembly => "src/test/LiteGuard.Specifications/bin/Debug/LiteGuard.Specifications.dll" },
  { :console => xunit_console_net40, :assembly => "src/test/LiteGuard.Pcl.Specifications/bin/Debug/LiteGuard.Specifications.dll" },
]

# NOTE (Adam): nuspec path values fail under Mono on Windows if using / or Mono on Linux if using \
nuspecs = [
  ["src/LiteGuard", ENV["OS"], "nuspec"].select { |token| token }.join("."),
  ["src/LiteGuard.Source", ENV["OS"], "nuspec"].select { |token| token }.join("."),
]

Albacore.configure do |config|
  config.log_level = :verbose
end

desc "Execute default tasks"
task :default => [:spec, :pack]

desc "Use Mono in Windows"
task :mono do
  ENV["Mono"] = "x"
  if ARGV.length == 1 && ARGV[0] = "mono"
    Rake::Task["default"].invoke
  end
end

desc "Restore NuGet packages"
exec :restore do |cmd|
  prepare_task cmd, nuget_console[:command], nuget_console[:net_version]
  cmd.parameters << "restore #{solution}"
end

desc "Clean solution"
task :clean do
  FileUtils.rmtree output
  execute_build [:Clean], solution
end

desc "Build solution"
task :build => [:clean, :restore] do
  execute_build [:Build], solution
end

desc "Execute specs"
task :spec => [:build] do
  execute_xunit specs
end

desc "Prepare source code for packaging"
task :src do
  File.open("src/LiteGuard/Guard.cs") { |from|
    contents = from.read
    contents.sub!(/.*namespace LiteGuard/m, 'namespace $rootnamespace$')
    contents.sub!(/public static class/, 'internal static class')
    File.open("src/LiteGuard/bin/Release/Guard.cs.pp", "w+") { |to| to.write(contents) }
  }
end

desc "Create the nuget packages"
task :pack => [:build, :src] do
  FileUtils.mkpath output
  execute_nugetpack nuspecs, nuget_console, output
end

def execute_build(targets, solution)
  build = use_mono ? XBuild.new : MSBuild.new
  build.properties = { :configuration => :Release }
  build.targets = targets
  build.solution = solution
  build.verbosity = use_mono ? :normal : :minimal
  build.parameters << "/nologo"
  build.execute
end

def execute_xunit(tests)
  tests.each do |test|
    cmd = Exec.new
    prepare_task cmd, test[:console][:command], test[:console][:net_version]
    cmd.parameters << test[:assembly] << "/html" << fix_path(test[:assembly] + ".TestResults.html") << "/xml" << fix_path(test[:assembly] + ".TestResults.xml")
    cmd.execute  
  end
end

def execute_nugetpack(nuspecs, nuget_console, output)
  nuspecs.each do |nuspec|
    cmd = Exec.new
    prepare_task cmd, nuget_console[:command], nuget_console[:net_version]
    cmd.parameters << "pack" << nuspec << "-Version" << @version << "-OutputDirectory" << output
    cmd.execute
  end
end

def prepare_task(task, command, net_version)
    if use_mono then
      task.command = "mono"
      task.parameters << "--runtime=v" + net_version << command
    else
      task.command = command
    end  
end

def fix_path(path)
  if is_windows then
    return File.expand_path(path)
  else
    return path
  end
end

def use_mono
  return !is_windows || ENV["Mono"]
end

def is_windows
  return ENV["OS"] == "Windows_NT"
end
