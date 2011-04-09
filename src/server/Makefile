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
	pip install tornado
	pip install py-bcrypt

init-db:
	python db/insert-questions.py

kill:
	sudo ps a | grep distrivia | grep -v grep | cut -d" " -f1 | sudo xargs kill -9
	sudo ps a | grep server.py | grep -v grep | cut -d" " -f1 | sudo xargs kill -9

run launch: kill
	rm /home/ec2-user/server.log
	python server.py --logging=info --log_file_prefix=/home/ec2-user/server.log

test:
	python runner.py test

clean:
	@rm -rf *.pyc
