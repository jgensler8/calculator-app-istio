# Calculator App w/ [istio](https://istio.io/about/)

Runs on Minikube.

Check out the blog article [here](https://medium.com/@jeffzzq/linkerd-vs-istio-my-2-1e16557891a6).

Most of the code is the same as my Linkerd example.

I have committed the `istio-0.1.5` directory so people could diff my changes to any later configuration. These changes include adding `NodePort` and correcting the port that the Mixer exposes its metrics on.
