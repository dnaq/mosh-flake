{ pkgs ? import <nixpks> {}, sources }:
pkgs.mosh.overrideAttrs(old: {
  src = sources.mosh;
  postPatch = ''
    substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${pkgs.openssh}/bin/ssh"
    substituteInPlace scripts/mosh.pl \
      --subst-var-by mosh-client "$out/bin/mosh-client"
  '';
  patches = let p = builtins.elemAt old.patches; in [ (p 0) (p 1) (p 2) (p 4) ];
})