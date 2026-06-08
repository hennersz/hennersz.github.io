# morti.net

Personal site built with [Astro](https://astro.build) and deployed to GitHub Pages.

## Development

Requires [Nix](https://nixos.org) with flakes enabled.

```sh
nix develop --impure
```

| Command | Action |
| :--- | :--- |
| `run` | Start dev server at `localhost:4321` |
| `lint` | Run all linters |
| `format` | Run all formatters |
| `nix build` | Build production site to `./result/` |
