{
  description = "Zero-Overhead eBPF OTLP Telemetry Daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-ninja = {
      url = "github:pdpartners/nix-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-ninja,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    buildEnvironment = with pkgs; [
      protobuf-c
      elfutils
      bpftool
      libbpf
      clang
      llvm
      zlib
    ];
  in {
    packages.${system}.default = nix-ninja.lib.${system}.buildNinjaPackage {
      pname = "siphon";
      version = "0.1.0";
      src = ./.;
      ninjaFile = "./build.ninja";
      nativeBuildInputs = buildEnvironment;
    };
  };
}
