require 'fileutils'

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
  end
end