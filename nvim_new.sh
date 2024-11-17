#!/bin/bash
XDG_CONFIG_HOME="$HOME/.config/nvim_new"
XDG_DATA_HOME="$HOME/.local/share/nvim_new"
exec nvim "$@"
