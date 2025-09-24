# Top-level Makefile for building all questions
QUESTIONS = q1 q2 q3 q4 q5

.PHONY: all clean $(QUESTIONS)

all: $(QUESTIONS)

# Build each question
$(QUESTIONS):
	@echo "----------------------------------------"
	@echo "Building $@"
	@echo "----------------------------------------"
	$(MAKE) -C $@

# Clean all questions
clean:
	@echo "Cleaning all questions..."
	@for dir in $(QUESTIONS); do \
		echo "Cleaning $$dir..."; \
		$(MAKE) -C $$dir clean; \
	done

# Show help
help:
	@echo "Available targets:"
	@echo "  all      - Build all questions (default)"
	@echo "  clean    - Clean all questions"
	@echo "  q1..q5   - Build specific question"
	@echo "  help     - Show this help message"
	@echo
	@echo "Examples:"
	@echo "  make         - Build all questions"
	@echo "  make -j      - Build all questions in parallel"
	@echo "  make q1      - Build only question 1"
	@echo "  make clean   - Clean all questions"
