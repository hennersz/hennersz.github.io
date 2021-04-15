{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell {
  # buildInputs is for dependencies you'd need "at run time",
  # were you to to use nix-build not nix-shell and build whatever you were working on
  buildInputs = [
    bundler 
    ruby_2_7
    jekyll
  ];
}