{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "test1.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "seafile.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "seafile.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "seafile.labels" -}}
helm.sh/chart: {{ include "seafile.chart" . }}
{{ include "seafile.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}


{{/*
volumes for ...
*/}}
{{- define "seafile.volumes" -}}
- name: {{ include "seafile.fullname" . }}-tmp
  {{- toYaml .Values.seafileConfig.tmpDirVolume | nindent 2 }}
{{/*- with .Values.seafileConfig.customVolumes }}
{{ toYaml . }}
{{- end -*/}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "seafile.selectorLabels" -}}
app.kubernetes.io/name: {{ include "seafile.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

