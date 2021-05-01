# React Native bundle step

[Bitrise](https://bitrise.io) step for bundling React Native apps

Calls `npx react-native bundle`.

Options:

- `--platform` Either "ios" or "android"
- `--entry-file` Path to the root JS file
- `--bundle-output` File name where to store the resulting bundle
- `--sourcemap-output` File name where to store the sourcemap file for resulting bundle
- `--assets-dest` Directory name where to store assets referenced in the bundle
- `--dev` If false, warnings are disabled and the bundle is minified
