help default:
		@echo ""
		@echo "Make targets available:"
		@echo ""
		@echo "  make all          - Build every paper with content"
		@echo "  make phase-zero   - Build phase one paper"
		@echo "  make phase-one    - Build phase one paper"
		@echo "  make phase-two    - Build phase two paper"
		@echo "  make phase-three  - Build phase three paper"
		@echo "  make help         - Display this help message"
		@echo ""


DIRS=phase-zero phase-one phase-two phase-three

clean:
	@$(foreach pdir, $(DIRS), $(shell cd $(pdir) && make clean ))

all:
	$(shell cd phase-zero && make -r build-paper )
	$(shell cd phase-one && make -r build-paper )
	$(shell cd phase-two && make -r build-paper )
	$(shell cd phase-three && make -r build-paper )

phase-zero:
	$(shell cd phase-zero && make -r build-paper )

phase-one:
	$(shell cd phase-one && make -r build-paper )

phase-two:
	$(shell cd phase-two && make -r build-paper )

phase-three:
	$(shell cd phase-three && make -r build-paper )
