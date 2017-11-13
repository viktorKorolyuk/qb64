# qb64

--Forked from: Galleondragon/qb64--

## Table of contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
  - [Problems (Linux and OSX)](#problems-during-installation-in-linux-and-osx)

## Prerequisites

### General

- Working computer

### Os dependant

- MacOSX
  - Latest version of [Xcode](https://developer.apple.com/xcode/).

## Setup.

To begin using qb64 run the appropriate command for your system:


For Linux:

```bash
./setup_linux.sh
```

For MacOSX:

```bash
./setup_osx.command
```

For windows:

```bat
start setup_win.bat
```

### Problems during installation in Linux and OSX

If you have problems running the install scripts under Linux (./setup_lnx.sh) or OS X (./setup_osx.command), run the following line in terminal, from your QB64 folder:

For Linux:

```bash
find . -name '*.sh' -exec sed -i "s/\r//g" {} \;
```

For OS X:

```bash
find . -name '*.command' -exec perl -pi -e 's/\r\n|\n|\r/\n/g' {} \;
```

Explanation:
The code finds any executables in the directory and removes any return characters. It seems the issue is no longer present in the current builds.

\[[source](http://www.qb64.net/forum/index.php?topic=13359.msg115525#msg115525)\]

## Useful/Interesting links

- [qb64 Wiki](http://www.qb64.net/wiki/index.php/Main_Page)
- [qb64.org](https://qb64.org/)
  - A tool called [inform](https://www.qb64.org/inform/) which allows the user to create QB64 form applications utilising a graphical user interface.