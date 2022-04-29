# pwn_lab
A portable reverse engineering and pwn environment using docker.

This repository is a fork of https://github.com/cboin/re_lab that was updated to include packages useful for exploit development, support for binaries using the 32-bit i386 architecture, as well as fixing issues with outdated dependencies.

### Installing

Building the docker image:
```bash
$ docker build -t pwn_lab .
```

Running the docker container:
```bash
$ ./run_container.sh
```

### Shared folders

* /share_ro - read only access to access installation of packages
* /share_rw - to be able to write and share the results with host system

## Authors

* **r1ghtwr0ng** - *Current pwn_lab maintainer*

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [PurpleBooth](https://github.com/PurpleBooth) - [README-Template.md](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [cboin](https://github.com/cboin) - [re_lab](https://github.com/cboin/re_lab)
