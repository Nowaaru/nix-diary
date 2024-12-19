{
  inputs,
  stdenv,
}: color:
stdenv.mkDerivation {
  pname = "tela-icons";
  version = "2024-09-04";

  src = inputs.tela-icons;

  installPhase = ''
    #!/env/bin/bash

    cd $src;
    ./install.sh -c "${color}" -d "$out"
  '';
}
