# Settings for zsh-autosuggestions (the plugin itself is loaded later by .zshrc)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)   # history first, fall back to tab-completion candidates
bindkey '^ ' autosuggest-accept                 # ctrl + space accepts the whole suggestion
                                                # ctrl + -> (forward-word) accepts the next word
