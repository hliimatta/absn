# absn
Small command line tool for absence.io time tracker.

**This project is under development and may contain errors. Feel free to submit issues and Pull Requests.**

## Installation

Build application:

```
crystal build --release --no-debug src/app.cr
```

## Configuration

Add .absn.json file to your homedirectory and add your absence.io api credentials:

```
{
  "id" : [YOUR API_ID],
  "key": [YOUR API_KEY]
}
```

## Usage

```shell
$ absn -h

  Usage: absn [options] [command]
  
  Options:
    -h, --help  output usage information
  
  Commands:
    w           start/switch to work
    b           start/switch to break
    s           stop
``` 
```shell
$ absn
Working since 14.06.2023 18:00 - 0h 43m (0h 0m)
```

```shell
$ absn w
Working since 14.06.2023 18.00
```

```shell
$ absn b
On a break since 14.06.2023 18:00 - 0h 43m (0h 0m)
```

```shell
$ absn s
Last: 14.06.2023 - 1h 20m - Total: 1h 20m (0h 0m)
```

## License

[The MIT License](http://opensource.org/licenses/MIT)

Copyright (c) 2023 Harri Liimatta
