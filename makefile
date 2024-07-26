TARGET_DIR := $$HOME
STOW_OPTIONS := --verbose --target=$(TARGET_DIR)

all: 
	@echo "Stowing all directories..."
	stow $(STOW_OPTIONS) --adopt --no-folding */

delete: 
	@echo "Deleting all stowed directories..."
	stow $(STOW_OPTIONS) --delete */

.PHONY: all delete
