run:
	docker build --no-cache -t proxy .
	docker run -t proxy

validate:
	# Install circleci with brew install circleci
	circleci config validate

