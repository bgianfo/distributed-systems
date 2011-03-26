help default:
		@echo ""
		@echo "Make targets available:"
		@echo ""
		@echo "  make deps    - Fetch/install all the dependencies for the server"
		@echo "  make init-db - Insert the question data into the db"
		@echo "  make launch  - Build and launch the server"
		@echo "  make run     - Alias for launch"
		@echo "  make test    - Run the server unit tests, requires a Riak instance running"
		@echo "  make clean   - Clean out pyc files"
		@echo "  make help    - Display this help message"
		@echo ""

deps:
	pip install flask
	pip install riak

init-db:
	python db/insert-questions.py

run lauch:
	python distrivia.py

test:
	python distrivia-tests.py

clean:
	@rm -rf *.pyc
