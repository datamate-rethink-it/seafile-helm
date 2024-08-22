# Development

`_dev.yaml` contains k8s manifests to test the chart against standalone services (e.g. with all the subcharts disabled).
The manifests can be applied using `kubectl apply -f _dev.yaml`.

**Note:** You manually need to create the buckets (`seafile-{blocks,commits,fs}`).
