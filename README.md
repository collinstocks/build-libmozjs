# build-libmozjs
Download and build libmozjs.

## Usage

To compile the version of libmozjs used in Firefox 53.0:

```bash
make libmozjs-53.0
```

More generally, to compile the version of libmozjs used in a particular version of Firefox:

```bash
make libmozjs-<firefox_version>
```

If your build machine has enough memory, you can parallelize your build:

```bash
make -j 4 libmozjs-53.0
```

To install system-wide:

```bash
sudo make install-53.0
```

That's it.
