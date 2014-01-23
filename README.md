# The Tryrb Gem

[![Gem Version](https://badge.fury.io/rb/tryrb.png)](https://rubygems.org/gems/tryrb)
[![Dependency Status](https://gemnasium.com/tony612/tryrb.png)](https://gemnasium.com/tony612/tryrb)
[![Build Status](https://travis-ci.org/tony612/tryrb.png?branch=master)](https://travis-ci.org/tony612/tryrb)
[![Coverage Status](https://coveralls.io/repos/tony612/tryrb/badge.png?branch=master)](https://coveralls.io/r/tony612/tryrb?branch=master)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/tony612/tryrb/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

#### Try ruby in a fascinating way

Create and execute a temp file by one command.

## Installation

```
$ gem install tryrb
```

## Why creating this?

Maybe you often try ruby scripts like this:

```
$ cd ~/tmp
$ vim foooooooo.rb
$ ruby foooooooo.rb
```

You have to change working directory, figure out a name, finally try to
find the right file to run.It's bothering! :anger:

But this gem provide an easy way to do this. :yellow_heart:

## Usage

##### The simplest and fastest way:

```
$ tryrb c(reate)
# Editing ruby code
$ tryrb e(xec)
```
A file named, for exmaple, `201401010909.rb` will be created and executed.

More options:

### Create a temp file

Specify a name

```
$ tryrb create foo
```

A file named, for exmaple, `201401010909_foo.rb` will be created.

### Execute a ruby script

Last one file in your temp dir

```
$ tryrb exec
```

The last one file containing `foo`

```
$ tryrb exec foo
```

Nth from the bottom file

```
$ tryrb exec -l n
```

Nth from the bottom file containing name `foo`

```
$ tryrb exec -l n foo
```

### Config

You can configure your editor and temp directory via a file in `~/.tryrbrc`, it looks like this:

```yaml
tmp_dir: ~/tmp/tryrb
editor: vim
```

So that the file your create will be created using vim in `~/tmp/tryrb` directory.

### Alias

`c` is alias of `create`, and `e` is alias of `exec`.

### Get help

```
$ tryrb help command
```

The command is `create`, `c`, `exec` or `e` for the moment.

## Contributing

Welcome contributing by forking, sending [pull requests](/../../pulls) or opening [issues](/../../issues).

## Copyright

Copyright (c) 2014 Tony Han. See [LICENSE][] for details.

[license]: LICENSE.md

