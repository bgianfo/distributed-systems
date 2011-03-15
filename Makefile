help default:
		@echo ""
		@echo "Make targets available:"
		@echo ""
		@echo "  make all     - Complete a full build of everything from scratch"
		@echo "  make launch  - Build and launch the server"
		@echo "  make run     - Alias for launch"
		@echo "  make server  - Build the system server"
		@echo "  make clients - Build all possible clients for this machine"
		@echo "  make papers  - Build all phase 0-3 papers"
		@echo "  make doc     - Build all documentation in doc"
		@echo "  make bundle  - Build the papers & documentation and package it for distribution"
		@echo "  make zip     - Alias for bundle"
		@echo "  make help    - Display this help message"
		@echo ""

all: server clients papers doc

zip: bundle
bundle: papers doc
		@rm -rf ds-deliverable.zip		
		@rm -rf /tmp/ds-deliverable
		@mkdir  /tmp/ds-deliverable
		@cp -rf * /tmp/ds-deliverable/.
		zip ds-deliverable.zip /tmp/ds-deliverable
		@rm -rf /tmp/ds-deliverable

papers:
		$(shell cd papers && make -r all )

