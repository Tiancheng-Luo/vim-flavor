Feature: Caching
  As a lazy Vim user
  I want to cache repositories of plugins which are installed before
  So that next installation will be finished very fast

  Background:
    Given a temporary directory called 'tmp'
    And a home directory called 'home' in '$tmp/home'
    And a repository 'foo' with versions '1.0.0 1.0.1 1.0.2'
    And flavorfile
      """
      flavor '$foo_uri', '~> 1.0'
      """
    And I run vim-flavor with 'install'
    And I disable network to the original repository of 'foo'

  Scenario: Install plugins - locked and compatible with new flavorfile
    Given I delete '$home/.vim'
    When I run vim-flavor with 'install' again
    Then I get lockfile
      """
      $foo_uri (1.0.2)
      """
    And I get flavor 'foo' with '1.0.2' in '$home/.vim'

  Scenario: Install plugins - locked but incompatible with new flavorfile
    Given I edit flavorfile as
      """
      flavor '$foo_uri', '~> 2.0'
      """
    When I run vim-flavor with 'install', though I know it will fail
    Then I see error message like 'fatal: \S+ does not appear to be a git repository'

  Scenario: Install plugins - not locked
    Given I delete lockfile
    When I run vim-flavor with 'install', though I know it will fail
    Then I see error message like 'fatal: \S+ does not appear to be a git repository'

  Scenario: Upgrading plugins
    When I run vim-flavor with 'upgrade', though I know it will fail
    Then I see error message like 'fatal: \S+ does not appear to be a git repository'
