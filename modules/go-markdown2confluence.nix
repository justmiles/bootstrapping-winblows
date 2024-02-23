{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-markdown2confluence";
  version = "3.4.6";
  doCheck = false;
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "justmiles";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xK5D0zbYnIrfObm9cfbfzGCa1mFsmDzhvG2yxLscdbM=";
  };

  ldflags = [
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/go-markdown2confluence $out/bin/markdown2confluence
  '';

  meta = with lib; {
    description = "Push markdown files to Confluence Cloud";
    changelog = "https://github.com/justmiles/go-markdown2confluence/releases/tag/v${version}";
    homepage = "https://github.com/justmiles/go-markdown2confluence";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    license = licenses.mit;
    maintainers = with maintainers; [ justmiles ];
    mainProgram = "markdown2confluence";
  };
}
