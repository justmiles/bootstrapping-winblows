{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "CodeGPT";
  version = "0.8.0";
  doCheck = false;
  vendorHash = "sha256-8GKjoRdkqTtiCTutlimN9RbL7c5bOpYQycXfdQu9aq0=";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bK8DIBj+dHT9OCJfrl9m6Xh/vHETRwbnaJI04ID1xNQ=";
  };

  subPackages = [ "cmd/codegpt" ];

  ldflags = [
    "-X github.com/appleboy/CodeGPT/cmd.Version=${version}"
  ];

  meta = with lib; {
    description = ''
      A CLI written in Go language that writes git commit messages or do a code review brief for you using 
      ChatGPT AI (gpt-4, gpt-3.5-turbo model) and automatically installs a git prepare-commit-msg hook.
    '';
    changelog = "https://github.com/appleboy/CodeGPT/releases/tag/v${version}";
    homepage = "https://github.com/appleboy/CodeGPT";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    license = licenses.mit;
    maintainers = with maintainers; [ appleboy ];
    mainProgram = "codegpt";
  };
}
