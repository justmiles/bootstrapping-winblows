{ lib
, nodejs-18_x
, makeWrapper
, stdenv
, fetchurl
}:

let
  nodejs = nodejs-18_x;
in

stdenv.mkDerivation rec {

  pname = "code-server";
  version = "4.21.1";
  nativeBuildInputs = [ makeWrapper nodejs ];
  propagatedBuildInputs = [ nodejs ];
  propagatedNativeBuildInputs = [ ];

  src = (
    fetchurl {
      url = "https://github.com/coder/code-server/releases/download/v${version}/code-server-${version}-linux-amd64.tar.gz";
      sha256 = "sha256-iuXeqzJ0m7m7IACbFOuw+sASqoJmDPyRssxb1n2vcJs=";
    }
  );

  installPhase = ''
    mkdir -p $out/bin
    tar -xzf ${src} -C $out --strip-components=1
    rm -rf $out/lib/node

    ln -s ${nodejs}/bin/node $out/lib/node
    ln -s ${nodejs}/bin/node $out/lib/vscode/node

    makeWrapper "${nodejs}/bin/node" "$out/bin/code-server" --add-flags "$out/out/node/entry.js"
  '';

  passthru = {
    executable = pname;
  };

  meta = with lib; {
    description = "VS Code in the browser";
    longDescription = "Run VS Code on any machine anywhere and access it in the browser.";
    homepage = "https://github.com/coder/code-server";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [ maintainers.offline ];
  };
}

