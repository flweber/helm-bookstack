{{/*
Shared Labels
*/}}
{{- define "bookstack.labels" -}}
app.kubernetes.io/name: {{ include "bookstack.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: {{ include "bookstack.name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | default "Helm" | quote }}
{{- end }}

{{/*
Basic Name
*/}}
{{- define "bookstack.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "bookstack.fullname" -}}
{{ printf "%s-%s" .Release.Name (include "bookstack.name" .) }}
{{- end }}

{{/*
Secret‑Name for database credentials
*/}}
{{- define "bookstack.db.secretName" -}}
{{ printf "%s" .Values.db.auth.existingSecret }}
{{- end }}

{{- define "bookstack.db.serviceName" -}}
{{ printf "%s-db-headless" .Release.Name }}
{{- end }}

{{- define "bookstack.redis.serviceName" -}}
{{ printf "%s-redis-headless" .Release.Name }}
{{- end }}

{{- define "bookstack.image.registry" -}}
{{- if .Values.bookstack.image.registry -}}
{{ printf "%s/" .Values.bookstack.image.registry }}
{{- else if .Values.global.imageRegistry -}}
{{ printf "%s/" .Values.global.imageRegistry }}
{{- else -}}
{{ print "" }}
{{- end -}}
{{- end }}

{{- define "bookstack.image" -}}
{{ printf "%s%s/%s:%s" (include "bookstack.image.registry" .) .Values.bookstack.image.repository .Values.bookstack.image.name (default .Chart.AppVersion .Values.bookstack.image.tag) }}
{{- end }}

{{- define "bookstack.app-key" -}}
{{ printf "%s-app-key" .Release.Name }}
{{- end }}

{{- define "bookstack.secret" -}}
{{ include "bookstack.fullname" . }}
{{- end }}

{{- define "bookstack.mailpit.name" -}}
{{ printf "%s-mailpit" (include "bookstack.fullname" .) }}
{{- end }}

{{- define "bookstack.persistence.storageclass" -}}
{{- if .Values.bookstack.persistence.storageClass -}}
{{ printf "%s" .Values.bookstack.persistence.storageClass }}
{{- else if .Values.global.defaultStorageClass -}}
{{ printf "%s" .Values.global.defaultStorageClass }}
{{- else -}}
{{ print "" }}
{{- end -}}
{{- end }}
