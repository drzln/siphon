{
  description = "Zero-Overhead eBPF OTLP Telemetry Daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    substrate.url = "github:pleme-io/substrate";
    nix-ninja = {
      url = "github:pdtpartners/nix-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-ninja,
    substrate,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    flake-utils = substrate.inputs.flake-utils;

    buildEnvironment = with pkgs; [
      protobuf-c
      elfutils
      bpftool
      libbpf
      clang
      llvm
      zlib
    ];

    default = nix-ninja.lib.${system}.buildNinjaPackage {
      pname = "siphon";
      version = "0.1.0";
      src = ./.;
      ninjaFile = "./build.ninja";
      nativeBuildInputs = buildEnvironment;
    };
  in {
    inherit default;
    packages.${system}.default = default;
  };
}
