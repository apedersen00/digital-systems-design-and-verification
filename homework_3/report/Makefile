TARGET      := main
BUILD_DIR   := build
SRC         := $(TARGET).tex
PDF         := $(BUILD_DIR)/$(TARGET).pdf

# PDF viewer command. Change this if not using WSL.
VIEWER := xdg-open

# latexmk build command
LATEXMK = latexmk -lualatex -output-directory=$(BUILD_DIR) -interaction=nonstopmode

# --- Phony Targets ---
# We make 'all' phony to ensure latexmk always runs.
# latexmk has its own fast dependency checking.
.PHONY: all view watch clean help

# --- Main Targets ---

# Default target: running 'make' or 'make all' will build the PDF.
# This target no longer depends on the source files, forcing it to run every time.
all:
	@echo "================== Invoking latexmk =================="
	@mkdir -p $(BUILD_DIR)
	$(LATEXMK) $(SRC)
	@echo "================== Compilation Done ================="
	@# Verify that the PDF was actually created
	@if [ -f "$(PDF)" ]; then \
		echo "PDF available at: $(PDF)"; \
	else \
		echo "Error: PDF not created. Check build/main.log for errors."; \
		exit 1; \
	fi
	@echo " "

# Target to open the generated PDF
view: all
	@echo "Opening $(PDF)..."
	@$(VIEWER) $(PDF) >/dev/null 2>&1 &

# Target to watch for changes and recompile automatically
watch:
	@echo "Watching for file changes... Press Ctrl+C to stop."
	@mkdir -p $(BUILD_DIR)
	$(LATEXMK) -pvc $(SRC)

# Target to clean up all generated files
clean:
	@echo "Cleaning up generated files..."
	# latexmk's -C command cleans the root directory of aux files
	@latexmk -C $(SRC) > /dev/null 2>&1
	# Also remove the build directory itself
	@rm -rf $(BUILD_DIR)
	@echo "Cleanup complete."

# Target to display help information
help:
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  all      (default) Compile the LaTeX document correctly."
	@echo "  view     Compile the document and open the resulting PDF."
	@echo "  watch    Watch for changes and recompile automatically."
	@echo "  clean    Remove all generated files and the build directory."
	@echo "  help     Display this help message."
