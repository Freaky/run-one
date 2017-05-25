# run-one

This is a third-party reimplementation of Dustin Kirkland's [`run-one`][1]
utility, with various bugfixes, better portability, and some semantic differences.


## Requirements

A working `/bin/sh`, `flock` or `lockf`, `sha256` or `sha256sum`, and `pgrep`/`pkill`.

Tested on FreeBSD 11 and Debian jessie.


## Installation

/usr/local is the default PREFIX, provided to illustrate:

    % make && sudo make install PREFIX=/usr/local

Linux users will want to use `bmake`, as punishment for all the times BSD users
had to use `gmake`.

There is a deinstall target.


## Usage

run-one will exit with EX_TEMPFAIL if another instance of the given command is
running:

    % run-one sleep 60 &
    [1] 3544
    % run-one sleep 60
    zsh: exit 75    run-one sleep 60

run-this-one will kill the running command first:

    % run-one sleep 60 &
    [1] 16658
    % run-this-one sleep 60
    [1]  + exit 70    run-one sleep 60

run-one-constantly will run in a loop until interrupted, sleeping a second between
successful runs, and doubling it up to a limit of 60 seconds between unsuccessful:

    % run-one-constantly echo moo
    moo
    moo
    moo

run-one-until-success does the same, but exits the first time it succeeds.  Both
commands log failures, so be mindful of your sysadmin:

    % run-one-until-success false &
    [1] 92276
    % tail -f /var/log/messages |grep run-one
    .. run-one-until-success[92276]: last run failed (rc=1); sleeping 2 seconds
    .. run-one-until-success[92276]: last run failed (rc=1); sleeping 4 seconds
    .. run-one-until-success[92276]: last run failed (rc=1); sleeping 8 seconds

run-one-until-failure does the opposite, and will never log failures.

    % run-one-until-failure false
    zsh: exit 1     run-one-until-failure false

Commands can of course be mixed:

    % run-one-constantly true &
    [1] 85332
    % run-one true
    zsh: exit 75    run-one true
    % run-this-one true
    [1]  + exit 70    run-one-constantly true


## Notable differences with the [original run-one][1]

 * Runs on FreeBSD (and hopefully others).
 * `keep-one-running` is not provided.
 * `run-one-constantly` and `run-one-until-*` lock the supervision loop, rather
   than the command itself, so are safer to use in cronjobs etc.
 * Arguments are hashed more carefully, so `run-one frob "foo bar"` and
   `run-one frob foo bar` are correctly treated as distinct commands.
 * run-this-one only considers other instances of flock/lockf, instead of treating
   the argument list as a pattern to pass to pkill.
 * run-this-one only attempts to kill the children under lockf, not lockf itself,
   to allow them to exit cleanly.
 * run-this-one will time out after 60s if the children of the existing command
   refuse to die.
 * Uses $XDG_CACHE_HOME instead of ~/.cache or /dev/shm
 * Is less anal about ownership. If you want to have a group share a lock directory,
   have at it.


## Author

This version of `run-one` is written by Thomas Hurst.  Do not confuse it with
the original.


[1]: https://launchpad.net/run-one
[2]: https://github.com/dustinkirkland/run-one
[3]: http://blog.dustinkirkland.com/2011/02/introducing-run-one-and-run-this-one.html
