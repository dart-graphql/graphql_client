# High Level Roadmap

This library is based on the official [spec][1]. The list of supported features are listed here.
Another part of this project is to write a dart transformer that converts GQL query into dart (code generation).

The library is fully functional today but doesn't have a code generator yet. This is in the roadmap.

## Roadmap
- [ ] GQL Features:
  - [x] Fields
  - [x] Arguments
  - [x] Aliases
  - [x] Fragments
  - [x] Variables
  - [ ] Directives
  - [ ] Inline Fragments
- [ ] Code generation: convert GQL query into dart classes
   
[1]: http://facebook.github.io/graphql/