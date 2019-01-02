# Overview
In the process of provisioning or upgrading Kubernetes clusters, it is often valuable to 
create and expose a simple service and use as a test tool. A canary in the cluster, if you wish.

To that end, the **netbnucket/k8s-canary** and **netbucket/k8s-canary-https** images will do the job well. 
Based on the *httpr* project - https://github.com/netbucket/httpr - these images provide a compact,
standalone Web server that will respond back to any valid HTTP (or HTTPS) request with a JSON payload
capturing the details of the client HTTP transaciton in a simple, structured, readable format. 

These publicly available images will:
 * Act as an observable trace for HTTP/HTTPS traffic
 * Log and echo back incoming requests in JSON format
 * Support HTTP/2 (use the *netbucket/k8s-canary-https* variety for that)
 
 
## Which image to use?
The only difference between **netbucket/k8s-canary** and **netbucket/k8s-canary-https** is the fact that 
the latter supports HTTPS/TLS (with a self-signed, auto-generated TLS certificate) and supports HTTP/2. 
Plaintext over HTTP/2 is considered in bad taste, therefore, **netbucket/k8s-canary** being a plaintext
HTTP endpoint, supports HTTP 1.1 only.

**netbucket/k8s-canary** container will start the HTTP listener on port 80, 
whereas **netbucket/k8s-canary-https** container will start the HTTPS listener on port 443. 
(Being convential is a virtue in the world of distributed systems.)

## How to use these images for testing
Assuming that your new Kubernetes cluster is ready, and you can connect to it via *kubectl* or any
other means of managing your cluster, first run the canary in the cluster as you would any of your 
HTTP based services. For instance:

Create a simple deployment in your cluster:

  ```kubectl run k8s-canary-test --image=netbucket/k8s-canary --port 80```

Expose the deployment:

 ```kubectl expose deployment k8s-canary-test  --type=NodePort --name=k8s-canary-test```

If all goes well, your canary deployment will be available and accessible via *http://public-ip:node-port/* URL, where *public-ip* is the public IP address of your node, and *node-port* ss the NodePort value for your service.Then, using *cURL*, or pointing a Chrome browser to http://public-ip:node-port/foo/bar will show the following:

```JavaScript
{
    "remoteAddr": "XXX.XX.X.X:51832",
    "host": "YYY.YYY.YY.Y:8083",
    "method": "GET",
    "url": "/",
    "proto": "HTTP/1.1",
    "header": {
        "Accept": [
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
        ],
        "Accept-Encoding": [
            "gzip, deflate, br"
        ],
        "Accept-Language": [
            "en-US,en;q=0.9"
        ],
        "Connection": [
            "keep-alive"
        ],
        "Upgrade-Insecure-Requests": [
            "1"
        ],
        "User-Agent": [
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
        ]
    }
}
```

When using the **netbucket/k8s-canary-https**, remember to expose port 443, not port 80:

  ```kubectl run k8s-canary-test --image=netbucket/k8s-canary-https --port 443```

Happy debugging!
