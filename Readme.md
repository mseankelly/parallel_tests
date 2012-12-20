_The intent of this fork of grosser/parallel_tests is to make it work in the Windows environment._

Speedup Test::Unit + RSpec + Cucumber by running parallel on multiple CPUs (or cores).<br/>
ParallelTests splits tests into even groups(by number of tests or runtime) and runs each group in a single process with its own database.

Setup for Rails
===============

### Install
If you use RSpec: ensure you got >= 2.4

As gem

```ruby
# add to Gemfile
gem "parallel_tests", :group => :development
```
OR as plugin

    rails plugin install git://github.com/mseankelly/parallel_tests.git

```ruby
# add to Gemfile
gem "parallel", :group => :development
```

### Add to `config/database.yml`
ParallelTests uses 1 database per test-process, 2 processes will use `*_test` and `*_test2`.

```yaml
test:
  database: yourproject_test<%= ENV['TEST_ENV_NUMBER'] %>
```

### Create additional database(s)
    rake parallel:create

### Copy development schema (repeat after migrations)
    rake parallel:prepare

### Run!
    rake parallel:test          # Test::Unit
    rake parallel:spec          # RSpec
    rake parallel:features      # Cucumber

    rake parallel:test[1] --> force 1 CPU --> 86 seconds
    rake parallel:test    --> got 2 CPUs? --> 47 seconds
    rake parallel:test    --> got 4 CPUs? --> 26 seconds
    ...

Test by pattern (e.g. use one integration server per subfolder / see if you broke any 'user'-related tests)

    rake parallel:test[^test/unit] # every test file in test/unit folder
    rake parallel:test[user]  # run users_controller + user_helper + user tests
    rake parallel:test['user|product']  # run user and product related tests


### Example output

    2 processes for 210 specs, ~ 105 specs per process
    ... test output ...

    843 examples, 0 failures, 1 pending

    Took 29.925333 seconds

Loggers
===================

Even process runtimes
-----------------

Log test runtime to give each process the same runtime.

Rspec: Add to your `.rspec_parallel` (or `.rspec`) :

    If installed as plugin: -I vendor/plugins/parallel_tests/lib
    --format progress
    --format ParallelTests::RSpec::RuntimeLogger --out tmp/parallel_runtime_rspec.log

Test::Unit:  Add to your `test_helper.rb`:
```ruby
require 'parallel_tests/test/runtime_logger'
```

RSpec: SummaryLogger
--------------------

This logger logs the test output without the different processes overwriting each other.

Add the following to your `.rspec_parallel` (or `.rspec`) :

    If installed as plugin: -I vendor/plugins/parallel_tests/lib
    --format progress
    --format ParallelTests::RSpec::SummaryLogger --out tmp/spec_summary.log

RSpec: FailuresLogger
-----------------------

This logger produces pasteable command-line snippets for each failed example.

E.g.

    rspec /path/to/my_spec.rb:123 # should do something

Add the following to your `.rspec_parallel` (or `.rspec`) :

    If installed as plugin: -I vendor/plugins/parallel_tests/lib
    --format progress
    --format ParallelTests::RSpec::FailuresLogger --out tmp/failing_specs.log

Setup for non-rails
===================
    gem install parallel_tests
    # go to your project dir
    parallel_test test/
    parallel_rspec spec/
    parallel_cucumber features/

 - use ENV['TEST_ENV_NUMBER'] inside your tests to select separate db/memcache/etc.
 - Only run selected files & folders:

    parallel_test test/bar test/baz/foo_text.rb

Options are:

    -n [PROCESSES]                   How many processes to use, default: available CPUs
    -p, --pattern [PATTERN]          run tests matching this pattern
        --group-by [TYPE]            group tests by:
          found - order of finding files
          steps - number of cucumber steps
          default - runtime or filesize
    -m, --multiply-processes [FLOAT] use given number as a multiplier of processes to run
    -s, --single [PATTERN]           Run all matching files in only one process
    -e, --exec [COMMAND]             execute this code parallel and with ENV['TEST_ENV_NUM']
    -o, --test-options '[OPTIONS]'   execute test commands with those options
    -t, --type [TYPE]                test(default) / rspec / cucumber
        --non-parallel               execute same commands but do not in parallel, needs --exec
        --no-symlinks                Do not traverse symbolic links to find test files
    -v, --version                    Show Version
    -h, --help                       Show this.

You can run any kind of code in parallel with -e / --execute

    parallel_test -n 5 -e 'ruby -e "puts %[hello from process #{ENV[:TEST_ENV_NUMBER.to_s].inspect}]"'
    hello from process "2"
    hello from process ""
    hello from process "3"
    hello from process "5"
    hello from process "4"

<table>
<tr><td></td><td>1 Process</td><td>2 Processes</td><td>4 Processes</td></tr>
<tr><td>RSpec spec-suite</td><td>18s</td><td>14s</td><td>10s</td></tr>
<tr><td>Rails-ActionPack</td><td>88s</td><td>53s</td><td>44s</td></tr>
</table>

TIPS
====
 - [RSpec] add a `.rspec_parallel` to use different options, e.g. **no --drb**
 - [RSpec] delete `script/spec`
 - [[Spork](https://github.com/sporkrb/spork)] does not work with parallel_tests
 - [RSpec] remove --loadby from you spec/*.opts
 - [RSpec] Instantly see failures (instead of just a red F) with [rspec-instafail](https://github.com/grosser/rspec-instafail)
 - [Bundler] if you have a `Gemfile` then `bundle exec` will be used to run tests
 - [Cucumber] add a `parallel: foo` profile to your `config/cucumber.yml` and it will be used to run parallel tests
 - [Capybara setup](https://github.com/grosser/parallel_tests/wiki)
 - [Sphinx setup](https://github.com/grosser/parallel_tests/wiki)
 - [Capistrano setup](https://github.com/grosser/parallel_tests/wiki/Remotely-with-capistrano) let your tests run on a big box instead of your laptop
 - [SQL schema format] use :ruby schema format to get faster parallel:prepare`
 - `export PARALLEL_TEST_PROCESSORS=X` in your environment and parallel_tests will use this number of processors by default
 - [ZSH] use quotes to use rake arguments `rake "parallel:prepare[3]"`
 - [email_spec and/or action_mailer_cache_delivery](https://github.com/grosser/parallel_tests/wiki)
 - [Memcached] use different namespaces e.g. `config.cache_store = ..., :namespace => "test_#{ENV['TEST_ENV_NUMBER']}"`

TODO
====
 - add tests for the rake tasks, maybe generate a rails project ...
 - add unit tests for cucumber runtime formatter
 - make jRuby compatible [basics](http://yehudakatz.com/2009/07/01/new-rails-isolation-testing/)
 - make windows compatible

Authors
====
Forked from: [grosser/parallel_tests](http://github.com/grosser/parallel_tests)

[Michael Kelly](http://github.com/mseankelly)<br/>
m.sean.kelly AT gmail.com<br/>
License: MIT
