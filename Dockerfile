# A compact HTTP server instance suitable for testing a Kubernetes cluster.
# This image contains a standalone Web server that will respond back
# to the HTTP client with a JSON dump of the client request.
FROM netbucket/httpr

EXPOSE 80

ENTRYPOINT ["/httpr", "log", "-e", "-p"]
CMD ["-s=:80"]
