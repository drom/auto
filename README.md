[![NPM version](https://img.shields.io/npm/v/autodrom.svg)](https://www.npmjs.org/package/autodrom)[![Linux](https://github.com/drom/autodrom/actions/workflows/linux.yml/badge.svg)](https://github.com/drom/autodrom/actions/workflows/linux.yml)[![MacOS](https://github.com/drom/autodrom/actions/workflows/macos.yml/badge.svg)](https://github.com/drom/autodrom/actions/workflows/macos.yml)[![Windows](https://github.com/drom/autodrom/actions/workflows/windows.yml/badge.svg)](https://github.com/drom/autodrom/actions/workflows/windows.yml)

Automatic verilog from comments

## CLI use

Process multiple files, folders, globs

```
npx autodrom ...<FILE, DIR, GLOB>
```

Create SVG diagrams

```
npx autodrom --svg ...<FILE, DIR, GLOB>
```

Watch multiple files, folders, globs

```
npx autodrom --watch ...<FILE, DIR, GLOB>
```

### For other Image formats

```
inkscape examples/quadrature.v0.svg --export-type=wmf -o examples/quadrature.v0.wmf
```

Supported types:

svg, png, ps, eps, pdf, emf, wmf, xaml
