
- chezmoi install private files
- install codegpt and other non-nix binaries
- install VS code extensions
- configure vscode remote settings

        ```json
        {
            "nix.enableLanguageServer": true,
            "nix.serverPath": "nil",
            "nix.formatterPath": "nixpkgs-fmt",
            "nix.serverSettings": {
                    "nil": {
                    "formatting": { "command": ["nixpkgs-fmt"] }
                }
            },
            "editor.formatOnSave": true
        }
        ```
- configure vscode keybindings.json

        ```json
        [
            {
                "key": "ctrl+q",
                "command": "editor.action.commentLine",
                "when": "editorTextFocus && !editorReadonly"
            },
            {
                "key": "ctrl+/",
                "command": "-editor.action.commentLine",
                "when": "editorTextFocus && !editorReadonly"
            },
            {
                "key": "ctrl+d",
                "command": "editor.action.copyLinesDownAction",
                "when": "editorTextFocus && !editorReadonly"
            },
            {
                "key": "ctrl+shift+alt+down",
                "command": "-editor.action.copyLinesDownAction",
                "when": "editorTextFocus && !editorReadonly"
            }
        ]
        ```