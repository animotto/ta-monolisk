# Trickster Arts Monolisk reverse engineering
![GitHub](https://img.shields.io/github/license/animotto/ta-monolisk)
[![Tests](https://github.com/animotto/ta-monolisk/actions/workflows/tests.yml/badge.svg)](https://github.com/animotto/ta-monolisk/actions/workflows/tests.yml)

## Overview
This tool provides a sandbox for researching of the network API of the Monolisk mobile game, originally developed by Trickster Arts

## Disclaimer
This project is for research purposes only. All source code is provided as is. I don't condone of exploiting vulnerabilities or cheating in this game, you act at your own risk.

## Sandbox
It uses my [sandbox-ruby](https://github.com/animotto/sandbox-ruby) gem

The sandbox consists of the following contexts:

- `dungeon` Dungeons list
- `player` Managing your profile, avatars, cards, etc
- `query` Creating and analyzing queries to the API server
- `script` Running your own scripts to interact with the sandbox
- `top` Top players

## How to run it
Clone the repository to your local machine and prepare the environment:

```console
git clone https://github.com/animotto/ta-monolisk
cd ta-monolisk
bundle install
export RUBYLIB=$PWD/lib
```

Create a new account and write the credentials to the config named *my*:
```console
./bin/sandbox -n my
```

Run the sandbox with the config *my*:
```console
./bin/sandbox -c my
```

All config files are in your home directory *~/.ta-monolisk/configs/*

## Scripting
Script file should be in the *scripts* directory.

There are two entry points:
```ruby
# Executed when your script was started
def start
end

# Executed when your script was finished
def finish
end
```

There are several instance variables you can use inside your script:

- `@shell` Sandbox shell
- `@game` Game instance
- `@id` Job ID
- `@name` Script name
- `@args` Script arguments passed from the sandbox
- `@logger` Logger to write messages to the sandbox


## Contributing
Any suggestions are welcome, just open an issue on Github. If you want to contribute to the source code, you can fork this repository and submit a pull request.

## License
See the [LICENSE](LICENSE) file
