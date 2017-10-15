# Note

Conceptually

1. The json-file docker logger logs to /var/lib/docker/containers
2. The /var/log/pods folder has symlinks with the pods' names to the container logs
3. The /var/log/containers folder has symlinks with the containers and pods names to the pods logs folder

By adding all three locations, so we can follow symlinks, and logging the containers folder, we can get nice log output with descriptive filenames. We can also regex these names to get the pod and container.

# Recipes - Splunk

1. Get the free Splunk installer from: https://www.splunk.com/goto/Download_4_V1
2. Upload to a bucket
3. Create an EC2 instance
4. Download the image
5. Elevate, install

# Unpack splunk.
tar xvzf splunk_package_name.tgz -C /opt

# Start splunk.
/opt/splunk/bin/splunk start --accept-license

Installation instructions: https://docs.splunk.com/Documentation/Splunk/6.5.3/Installation/InstallonLinux

# Bonus

- [ ] Avoid first time login password reset warning
- [ ] Auto strip details from the logs

## Extracting the Pod Name, Container Name, Container ID etc

Use the following filter:

```
 | rex field=source "\/var\/log\/containers\/(?<pod>[a-zA-Z0-9-]*)_(?<namespace>[a-zA-Z0-9]*)_(?<container>[a-zA-Z0-9]*)-(?<conatinerid>[a-zA-Z0-9_]*)"
```

This example query shows all of the events from the counter logs:

```
source="/var/log/containers/counter-1-*"  | rex field=source "\/var\/log\/containers\/(?<pod>[a-zA-Z0-9-]*)_(?<namespace>[a-zA-Z0-9]*)_(?<container>[a-zA-Z0-9]*)-(?<conatinerid>[a-zA-Z0-9_]*)" | table time, host, namespace, pod, container, log
```


## Symlink Logs

To get logs with the container name and ID, it helps to have the symlinked logs. This only seems to work with Kubernetes 1.6 onwards, see this bug:

- https://github.com/minishift/minishift/issues/510

This means you should be running OpenShift 3.6 or onwards. To have symlinked logs, you must also run with the [`json-file` log driver](https://docs.docker.com/engine/admin/logging/json-file/).

# Important Documentation

- [Kubernetes - Cluster Administration - Logging](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [Splunk Universal Forwarder Image](https://hub.docker.com/r/splunk/universalforwarder/)

# Useful Reading

- Splunk, k8s, fluentd, syslog, loggerd and more: https://github.com/kubernetes/kubernetes/issues/24677