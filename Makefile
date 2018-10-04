.PHONY: default build deploy run

default: build

tag = geocodio/docker-mysql-backup-cron

build:
	docker build -t $(tag) .

deploy:
	docker push $(tag)	

run:
	docker run --rm --name=replication-monitor --env-file=.env $(tag)
