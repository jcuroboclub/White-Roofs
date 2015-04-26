GULP=gulp --require=coffee-script/register

define when-dependency-missing 
	@echo 'CHECKING FOR DEPENDENCY $1' 
	@command -v $1 >/dev/null 2>&1 || $2
endef


define npm-check
	$(call when-dependency-missing, $1, npm install -g $2)
endef

build:
	@${GULP} build

watch:
	@${GULP} watch

test:
	@${GULP} test

serve:
	ruby -run -e httpd ./dist -p3000

init:
	$(call npm-check, gulp,  gulp)
	$(call npm-check, coffee, coffee-script)
	@mkdir -p dist
	npm install

.PHONY: test
