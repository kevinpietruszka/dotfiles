BASE_OPTIONS := --verbose --no-folding
STOW_OPTIONS := $(BASE_OPTIONS) --stow
DELETE_OPTIONS := $(BASE_OPTIONS) --delete
HOME_DIR := $$HOME
GIT_DIR := $$HOME
NEOVIM_DIR := $$HOME/.config/nvim
GHOSTTY_DIR := $$HOME/.config/ghostty
TMUX_DIR := $$HOME 

# Default action - can be "stow" or "unstow"
ACTION ?= stow

all: neovim git tmux ghostty
	@echo "$(ACTION) operation completed for all packages"

clean: 
	@$(MAKE) ACTION=unstow all

neovim:
	@if [ "$(ACTION)" = "stow" ]; then \
		echo "Stowing neovim..."; \
		if [ ! -d "$(NEOVIM_DIR)" ]; then \
			echo "Making neovim config directory ..."; \
			mkdir -p $(NEOVIM_DIR); \
		fi; \
		stow $(STOW_OPTIONS) --target=$(NEOVIM_DIR) neovim; \
	else \
		echo "Unstowing neovim..."; \
		stow $(DELETE_OPTIONS) --target=$(NEOVIM_DIR) neovim; \
		if [ -d "$(NEOVIM_DIR)" ]; then \
			echo "Removing neovim config directory ..."; \
			rm -rf $(NEOVIM_DIR); \
		fi; \
	fi

ghostty:
	@if [ "$(ACTION)" = "stow" ]; then \
		echo "Stowing ghostty..."; \
		if [ ! -d "$(GHOSTTY_DIR)" ]; then \
			echo "Making ghostty config directory ..."; \
			mkdir -p $(GHOSTTY_DIR); \
		fi; \
		stow $(STOW_OPTIONS) --target=$(GHOSTTY_DIR) ghostty; \
	else \
		echo "Unstowing ghostty..."; \
		stow $(DELETE_OPTIONS) --target=$(GHOSTTY_DIR) ghostty; \
		if [ -d "$(GHOSTTY_DIR)" ]; then \
			echo "Removing ghostty config directory ..."; \
			rm -rf $(GHOSTTY_DIR); \
		fi; \
	fi

git:
	@if [ "$(ACTION)" = "stow" ]; then \
		echo "Stowing git..."; \
		stow $(STOW_OPTIONS) --target=$(GIT_DIR) git; \
	else \
		echo "Unstowing git..."; \
		stow $(DELETE_OPTIONS) --target=$(GIT_DIR) git; \
	fi

tmux:
	@if [ "$(ACTION)" = "stow" ]; then \
		echo "Stowing tmux..."; \
		stow $(STOW_OPTIONS) --target=$(TMUX_DIR) tmux; \
	else \
		echo "Unstowing tmux..."; \
		stow $(DELETE_OPTIONS) --target=$(TMUX_DIR) tmux; \
	fi

.PHONY: all neovim git tmux clean ghostty
