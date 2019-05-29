{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "moderngreek.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "moderngreek.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate dashboard_base_url
*/}}
{{- define "moderngreek.dashboard_base_url" }}
{{- if (not (empty .Values.config.dashboard_base_url)) }}
{{- printf .Values.config.dashboard_base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := (index .Values.ingress.hosts.dashboard 0) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- printf "http://%s-dashboard" (include "moderngreek.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate store_base_url
*/}}
{{- define "moderngreek.store_base_url" }}
{{- if (not (empty .Values.config.store_base_url)) }}
{{- printf .Values.config.store_base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := (index .Values.ingress.hosts.store 0)) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- printf "http://%s-store" (include "moderngreek.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mongo_url
*/}}
{{- define "moderngreek.mongo_url" }}
{{- $mongo := .Values.config.mongo }}
{{- if $mongo.internal }}
{{- printf "mongodb://%s-mongo:27017/%s" (include "moderngreek.fullname" . ) $mongo.database }}
{{- else }}
{{- if $mongo.url }}
{{- printf $mongo.url }}
{{- else }}
{{- $credentials := (empty $mongo.username | ternary "" (printf "%s:%s" $mongo.username $mongo.password)) }}
{{- printf "mongodb://%s@%s:%s/%s" $credentials $mongo.host $mongo.port $mongo.database }}
{{- end }}
{{- end }}
{{- end }}
