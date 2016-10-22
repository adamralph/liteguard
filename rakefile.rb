require 'albacore'
require 'fileutils'

version = IO.read("src/LiteGuard/Properties/CommonAssemblyInfo.cs").split(/AssemblyInformationalVersion\("/, 2)[1].split(/"/).first
version_suffix  = ENV["VERSION_SUFFIX"]
build           = (ENV["BUILD"] || "").rjust(6, "0");
build_suffix    = version_suffix.to_s.empty? ? "" : "-build" + build;
msbuild_command = "C:/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe"
xunit_console = "packages/xunit.runners.1.9.2/tools/xunit.console.clr4.exe"
nuget_console = ".nuget/NuGet.exe"
solution = "LiteGuard.sln"
logs = "artifacts/logs"
output = "artifacts/output"

acceptance_tests = [
  "tests/LiteGuard.Test.Acceptance.net35/bin/Release/LiteGuard.Test.Acceptance.net35.dll",
  "tests/LiteGuard.Test.Acceptance.net45/bin/Release/LiteGuard.Test.Acceptance.net45.dll",
]

nuspecs = [ "src/LiteGuard.nuspec", "src/LiteGuard.Source.nuspec", ]

Albacore.configure do |config|
  config.log_level = :verbose
end

desc "Execute default tasks"
task :default => [:accept, :pack]

directory logs

desc "Clean solution"
task :clean => [logs] do
  execute_msbuild solution, "Clean", msbuild_command, logs
end

desc "Build solution"
task :build => [:clean, logs] do
  execute_msbuild solution, "Build", msbuild_command, logs
end

desc "Execute acceptance tests"
task :accept => [:build] do
  acceptance_tests.each do |test|
    cmd = Exec.new
    cmd.command = xunit_console
    cmd.parameters << test << "/html" << File.expand_path(test + ".TestResults.html") << "/xml" << File.expand_path(test + ".TestResults.xml")
    cmd.execute
  end
end

desc "Prepare source code for packaging"
task :src do
  [{:source => "net35", :platform => "net35"} , {:source => "", :platform => "netstandard1.0"}].each do |file|
      File.open("src/LiteGuard.#{file[:source]}/Guard.cs") { |from|
        contents = from.read
        contents.sub!(/.*namespace LiteGuard/m, 'namespace $rootnamespace$')
        contents.sub!(/public static class/, 'internal static class')
        FileUtils.mkdir_p "src/contentFiles/cs/#{file[:platform]}/"
        File.open("src/contentFiles/cs/#{file[:platform]}/Guard.cs.pp", "w+") { |to| to.write(contents) }
      }
  end
end

directory output

desc "Create the nuget packages"
task :pack => [:build, :src, output] do
  nuspecs.each do |nuspec|
    cmd = Exec.new
    cmd.command = nuget_console
    cmd.parameters "pack #{nuspec} -Version #{version}#{version_suffix}#{build_suffix} -OutputDirectory #{output}"
    cmd.execute
  end
end

def execute_msbuild(solution, target, command, logs)
  cmd = Exec.new
  cmd.command = command
  cmd.parameters "#{solution} /target:#{target} /p:configuration=Release /nr:false /verbosity:minimal /nologo /fl /flp:LogFile=#{logs}/#{target}.log;Verbosity=Detailed;PerformanceSummary"
  cmd.execute
end
