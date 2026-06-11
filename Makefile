SKILLS_DIR ?= $(HOME)/.claude/skills

.PHONY: install uninstall list

install: ## Install all skills to the user skills directory
	@mkdir -p "$(SKILLS_DIR)"
	@cp -r skills/* "$(SKILLS_DIR)/"
	@echo "Installed skills to $(SKILLS_DIR)"

uninstall: ## Remove installed skills from the user skills directory
	@for skill in skills/*/; do \
		name="$$(basename "$$skill")"; \
		rm -rf "$(SKILLS_DIR)/$$name"; \
		echo "Removed $(SKILLS_DIR)/$$name"; \
	done

list: ## List skills available in this repo
	@ls -1 skills
