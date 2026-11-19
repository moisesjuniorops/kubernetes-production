{{- define "webapp.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}
{{- define "webapp.selector" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end }}
