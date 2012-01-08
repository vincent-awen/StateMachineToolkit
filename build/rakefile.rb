require 'rake/clean'

#task :default do
#    $stderr.puts "Howdy, World"


DOT_NET_PATH = "#{ENV["SystemRoot"]}\\Microsoft.NET\\Framework\\v4.0.30319"
NUNIT_EXE = "../packages/NUnit.2.5.10.11092/tools/nunit-console.exe"
SOURCE_PATH = ".."
OUTPUT_PATH = "../output"
CONFIG = "Debug"
 
CLEAN.include(OUTPUT_PATH)

task :default => ["clean", "build:all"]
 
namespace :build do
  
  task :all => [:compile, :test]
      
  desc "Build solutions using MSBuild"
  task :compile do
    solutions = FileList["#{SOURCE_PATH}/**/*.sln"]
    solutions.each do |solution|
      sh "#{DOT_NET_PATH}/msbuild.exe /p:Configuration=#{CONFIG} #{solution}"
    end
  end
   
  desc "Runs tests with NUnit"
  task :test => [:compile] do
    tests = FileList["#{OUTPUT_PATH}/**/*.Tests.dll"].exclude(/obj\//)
    sh "#{NUNIT_EXE} #{tests} /nologo /xml=#{OUTPUT_PATH}/TestResults.xml"
  end
  
end
