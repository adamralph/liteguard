require 'albacore'

version = IO.read("src/CommonAssemblyInfo.cs").split(/AssemblyInformationalVersion\("/, 2)[1].split(/"/).first
msbuild_command = "C:/Program Files (x86)/MSBuild/12.0/Bin/MSBuild.exe"
net20 = "2.0.50727"
net40 = "4.0.30319"
xunit_console = { :command => "src/packages/xunit.runners.1.9.2/tools/xunit.console.exe", :net_version => net20 }
nuget_console = { :command => "src/packages/NuGet.CommandLine.2.8.2/tools/NuGet.exe", :net_version => net40 }
solution = "src/LiteGuard.sln"
logs = "artifacts/logs"
output = "artifacts/output"

acceptance_tests = [
  "src/test/LiteGuard.Test.Acceptance.net35/bin/Debug/LiteGuard.Test.Acceptance.net35.dll",
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
task :default => [:accept, :pack]

desc "Use Mono in Windows"
task :mono do
  ENV["Mono"] = "x"
  if ARGV.length == 1 && ARGV[0] = "mono"
    Rake::Task["default"].invoke
  end
end

desc "Restore NuGet packages"
exec :restore do |cmd|
  prepare_task cmd, nuget_console
  cmd.parameters << "restore #{solution}"
end

directory logs

desc "Clean solution"
task :clean => [logs] do
  if use_mono
    execute_xbuild solution, "Clean"
  else
    execute_msbuild solution, "Clean", msbuild_command, logs
  end
end

desc "Build solution"
task :build => [:clean, :restore, logs] do
  if use_mono
    execute_xbuild solution, "Build"
  else
    execute_msbuild solution, "Build", msbuild_command, logs
  end
end

desc "Execute acceptance tests"
task :accept => [:build] do
  acceptance_tests.each do |test|
    cmd = Exec.new
    prepare_task cmd, xunit_console
    cmd.parameters << test << "/html" << fix_path(test + ".TestResults.html") << "/xml" << fix_path(test + ".TestResults.xml")
    cmd.execute
  end
end

desc "Prepare source code for packaging"
task :src do
  if !use_mono
    ["net35", "pcl", "sl5", "universal", "win8", "win81", "wp8", "wpa81"].each do |platform|
        File.open("src/LiteGuard.#{platform}/Guard.cs") { |from|
          contents = from.read
          contents.sub!(/.*namespace LiteGuard/m, 'namespace $rootnamespace$')
          contents.sub!(/public static class/, 'internal static class')
          File.open("src/LiteGuard.#{platform}/bin/Release/Guard.cs.pp", "w+") { |to| to.write(contents) }
        }
    end
  end
end

directory output

desc "Create the nuget packages"
task :pack => [:build, :src, output] do
  if !use_mono
    execute_nugetpack nuspecs, nuget_console, version, output
  end
end

def execute_xbuild(solution, target)
  build = XBuild.new
  build.properties = { :configuration => :MonoRelease }
  build.targets = [target]
  build.solution = solution
  build.verbosity = use_mono ? :normal : :minimal
  build.parameters << "/nologo"
  build.execute
end

def execute_msbuild(solution, target, command, logs)
  cmd = Exec.new
  cmd.command = command
  cmd.parameters "#{solution} /target:#{target} /p:configuration=Release /nr:false /verbosity:minimal /nologo /fl /flp:LogFile=#{logs}/#{target}.log;Verbosity=Detailed;PerformanceSummary"
  cmd.execute
end

def execute_nugetpack(nuspecs, console, version, output)
  nuspecs.each do |nuspec|
    cmd = Exec.new
    prepare_task cmd, console
    cmd.parameters << "pack" << nuspec << "-Version" << version << "-OutputDirectory" << output
    cmd.execute
  end
end

def prepare_task(task, console)
  if use_mono then
    task.command = "mono"
    task.parameters << "--runtime=v" + console[:net_version] << console[:command]
  else
    task.command = console[:command]
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
