SKILLS_DIR ?= $(HOME)/.claude/skills
AGENTS_DIR ?= $(HOME)/.claude/agents

.PHONY: install uninstall list

install: ## Install all skills and agents to the user Claude Code directories
	@mkdir -p "$(SKILLS_DIR)" "$(AGENTS_DIR)"
	@cp -r skills/* "$(SKILLS_DIR)/"
	@cp agents/*.md "$(AGENTS_DIR)/"
	@echo "Installed skills to $(SKILLS_DIR)"
	@echo "Installed agents to $(AGENTS_DIR)"

uninstall: ## Remove installed skills and agents from the user Claude Code directories
	@for skill in skills/*/; do \
		name="$$(basename "$$skill")"; \
		rm -rf "$(SKILLS_DIR)/$$name"; \
		echo "Removed $(SKILLS_DIR)/$$name"; \
	done
	@for agent in agents/*.md; do \
		name="$$(basename "$$agent")"; \
		rm -f "$(AGENTS_DIR)/$$name"; \
		echo "Removed $(AGENTS_DIR)/$$name"; \
	done

list: ## List skills and agents available in this repo
	@echo "Skills:"
	@ls -1 skills
	@echo "Agents:"
	@ls -1 agents | sed 's/\.md$$//'
