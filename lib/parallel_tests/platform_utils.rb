require 'fileutils'
require 'tmpdir'
require 'rbconfig'

module ParallelTests
  class PlatformUtils
    def self.rm_rf(list)
      FileUtils.rm_rf(list)
    end

    def self.rm_f(list)
      FileUtils.rm_f(list)
    end

    def self.mkdir_p(list)
      FileUtils.mkdir_p(list)
    end

    def self.mkdir(list)
      FileUtils.mkdir(list)
    end

    def self.tmpdir
      Dir.tmpdir
    end

    def self.dev_null_redirect
      windows? ? "> NUL" : "2>&1"
    end

    def self.dev_null
      windows? ? "NUL" : "/dev/null"
    end

    def self.touch(list)
      FileUtils.touch(list)
    end

    def self.windows?
      RbConfig::CONFIG['host_os'] =~ /mswin|mingw|windows|cygwin/i
    end
  end
end